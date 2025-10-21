# LSP (neovim/nvim-lspconfig + mason)

What it is
- Language Server Protocol configuration with automatic server installation via mason.nvim and mason-lspconfig. Provides go-to-def, hover, diagnostics, rename, code actions, etc.

Use cases
- Rich language features for Lua, Rust, Python, C/C++, Go, etc.

Key bindings (buffer-local on LSP attach)
- gD: Declaration
- gd: Definition
- K: Hover
- gi: Implementation
- <C-k>: Signature help
- <leader>wa / <leader>wr / <leader>wl: Workspace folders add/remove/list
- <leader>D: Type definition
- <leader>rn: Rename
- <leader>ca: Code action (also in visual mode)
- gr: References
- Diagnostics: [d / ]d prev/next, <leader>e float, <leader>q loclist
- Diagnostics toggles (global): <leader>dt (DiagnosticsToggle), <leader>dv (VirtualTextToggle)

Commands/Usage
- Servers auto-install via mason for: lua_ls, rust_analyzer, pyright, clangd, bashls, gopls.
- Use language features via the keymaps above once a server is attached.

Modify
- Server settings in lua/plugins/lsp.lua (per-server setup). Adjust ensure_installed, settings, capabilities.
- Diagnostics behavior in lua/config/diagnostics.lua; commands defined in lua/config/commands.lua.

Dependencies
- williamboman/mason.nvim, williamboman/mason-lspconfig.nvim
- j-hui/fidget.nvim (LSP status), folke/neodev.nvim (Lua dev)
