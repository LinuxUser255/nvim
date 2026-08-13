# Fix: Neovim Freezes Completely (No Keyboard/Mouse/RPC Response)

## Problem

Neovim would periodically freeze solid while editing Rust files — no response to
keyboard input, no response to mouse input, and (confirmed during investigation)
no response even to external `--remote-expr` RPC calls. Recovering required
killing the process from another terminal, with no swap file to recover unsaved
edits (`swapfile = false` in `lua/config/options.lua`).

This was the second time a Neovim freeze traced back to a plugin issue — see
also the Tabnine freeze fix (`git log --oneline | grep -i tabnine`, commit
`6fa6fa6`), which caused a freeze on opening netrw.

## Investigation

Process inspection of the frozen instance (both the `nvim .` client and the
`nvim --embed` server) showed:

- **0% CPU** on every thread — ruling out an infinite loop / busy spin.
- Main thread parked in `do_epoll_wait` — ruling out a blocked syscall
  (e.g. a hung subprocess read).
- `nvim --server /run/user/1000/nvim.<pid>.0 --remote-expr 'mode()'` also hung
  indefinitely — proving the freeze wasn't just "ignoring the keyboard," the
  entire msgpack-RPC/event loop had stopped servicing requests.
- The terminal's flow control (`ixon`/`ixoff`) was already disabled, ruling out
  the classic Ctrl-S/Ctrl-Q freeze.
- The user confirmed the freeze reliably follows **mouse interaction**.

## Root Cause

`lua/plugins/rust.lua` bound `K` (hover) and `<leader>ca` (code actions) through
**`simrat39/rust-tools.nvim`** (archived upstream, superseded by
`rustaceanvim`):

```lua
vim.keymap.set("n", "K", rt.hover_actions.hover_actions, opts)
vim.keymap.set("n", "<Leader>ca", rt.code_action_group.code_action_group, opts)
```

Both render their popups through **`ray-x/guihua.lua`**, a UI library that
implements its own blocking mouse/keyboard input-capture loop for its floating
menus, independent of Neovim's normal event dispatch. A mouse click or scroll
inside one of these popups could leave that loop waiting on an input event it
never received — wedging the main thread, and with it the entire editor,
since RPC and redraws share the same thread.

`K` is pressed constantly while reading code, which is why this kept recurring.

Note: `ray-x/guihua.lua` is also a dependency of `go.nvim`
(`lua/plugins/golang.lua`) for its own floating UI. That code path was not
touched by this fix and carries the same theoretical risk for Go files.

## Fixes Applied

### 1. Migrated `rust-tools.nvim` → `rustaceanvim` (`lua/plugins/rust.lua`)

`rustaceanvim` routes hover actions and code actions through `vim.ui.select`
instead of a custom blocking input loop, and is the actively maintained
successor to `rust-tools.nvim`.

```lua
{
  "mrcjkb/rustaceanvim",
  version = "^6",
  lazy = false,
  init = function()
    vim.g.rustaceanvim = {
      server = {
        on_attach = function(_client, bufnr)
          local opts = { buffer = bufnr, noremap = true, silent = true }
          vim.keymap.set("n", "K", function() vim.cmd.RustLsp({ "hover", "actions" }) end, opts)
          vim.keymap.set("n", "<Leader>ca", function() vim.cmd.RustLsp("codeAction") end, opts)
        end,
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = true,   -- must be boolean; see rust-anaylzer-checkonsave-warning.md
            check = { command = "clippy" },
            inlayHints = { ... },
          },
        },
      },
      dap = { adapter = { type = "executable", command = "lldb-vscode", name = "rt_lldb" } },
    }
  end,
}
```

### 2. Fixed a duplicate rust-analyzer LSP client (`lua/plugins/lsp.lua`, `lua/plugins/mason-lspconfig.lua`)

Migrating to rustaceanvim surfaced a second, pre-existing bug: **two competing
`rust_analyzer` LSP clients** were attaching to every Rust buffer. Traced with
a stack-traced monkey-patch of `vim.lsp.enable`, this came from two
independent things both calling `require("mason-lspconfig").setup()`:

- `lua/plugins/lsp.lua` — the "real" config, explicitly excluding
  `rust_analyzer` from `automatic_enable` so rustaceanvim owns it.
- `lua/plugins/mason-lspconfig.lua` — a second, redundant plugin spec (empty
  `ensure_installed`, `event = "BufReadPre"`) that called `.setup()` again
  with mason-lspconfig's *default* `automatic_enable = true`, silently
  starting a second client before the exclude in `lsp.lua` had any effect.

Fix: disabled the redundant spec in `mason-lspconfig.lua` (kept commented for
reference, matching the existing pattern used for the disabled Tabnine spec).
Also removed the now-redundant `lspconfig.rust_analyzer.setup()` call in
`lsp.lua` and guarded the generic `LspAttach` autocmd so it no longer
overwrites rustaceanvim's `K` / `<leader>ca` mappings with plain
`vim.lsp.buf.hover` / `vim.lsp.buf.code_action`.

Verified via headless test: `vim.lsp.get_clients({bufnr=0})` now returns
exactly one client (`rust-analyzer`) for `.rs` files.

### 3. Upgraded Neovim: nightly `v0.12.2-dev` → stable `v0.12.4`

The frozen instance was running a nightly/dev build
(`v0.12.2-dev-73+g55d3d1bbeb`), which carries more unreleased regressions than
a stable release. Rebuilt from the existing source checkout at
`~/Projects/neovim`:

```bash
cd ~/Projects/neovim
git fetch --tags origin
git checkout v0.12.4
rm -rf build
make CMAKE_BUILD_TYPE=Release CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=/usr/local"
sudo cmake --install build   # NOT `sudo make install` — see gotcha below
```

**Gotcha:** `sudo make install` re-triggers the `nvim` build target (its own
prerequisite) under root's environment before installing, which failed
silently for us with no useful output. Running `sudo cmake --install build`
directly against the already-built `build/` directory installed cleanly.

## Environment

- **Neovim:** upgraded `v0.12.2-dev-73+g55d3d1bbeb` → `v0.12.4` (stable)
- **Terminal:** Alacritty (ruled out — idle/responsive throughout the freeze)
- **Removed:** `simrat39/rust-tools.nvim`, `ray-x/guihua.lua` (as a Rust dependency)
- **Added:** `mrcjkb/rustaceanvim` (`^6`)
- **Related:** `docs/troubleshooting/rust-anaylzer-checkonsave-warning.md`,
  Tabnine freeze fix (commit `6fa6fa6`)

## If it happens again

1. From another terminal, check whether the frozen process is CPU-spinning or
   idle: `ps -L -o pid,tid,pcpu,stat,wchan:20,comm -p <pid>`.
2. Try RPC: `nvim --server /run/user/1000/nvim.<pid>.0 --remote-expr 'mode()'`.
   If this also hangs, it's a genuine main-thread wedge, not just an ignored
   keypress — worth a `gdb -p <pid> -batch -ex 'thread apply all bt'` for a
   backtrace before killing it, to actually pin down the culprit.
3. Check what was interacted with right before the freeze (which popup, mouse
   vs. keyboard) — that's what narrowed this one down to rust-tools/guihua.
