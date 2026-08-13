-- Rust-specific indentation, independent of the LSP/hover plugin below
vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  callback = function(ev)
    local bufnr = ev.buf
    vim.bo[bufnr].tabstop = 4
    vim.bo[bufnr].shiftwidth = 4
    vim.bo[bufnr].softtabstop = 4
    vim.bo[bufnr].expandtab = true
    vim.bo[bufnr].autoindent = true
    vim.bo[bufnr].smartindent = true
    -- Don't use cindent as it conflicts with smartindent/treesitter
    vim.bo[bufnr].cindent = false
  end,
})

return {
  -- Rust-specific plugin with enhanced features
  -- Replaces simrat39/rust-tools.nvim (archived upstream). rust-tools' hover_actions
  -- and code_action_group rendered their popups via guihua.lua, which runs its own
  -- blocking mouse/keyboard input-capture loop. A mouse click/scroll inside that
  -- popup could leave the loop waiting on an event it never received, freezing the
  -- whole editor (main thread wedged, not just the popup). rustaceanvim's hover
  -- actions/code actions go through vim.ui.select instead, so there's no custom
  -- blocking input loop to get stuck in.
  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    lazy = false,
    init = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(_client, bufnr)
            local opts = { buffer = bufnr, noremap = true, silent = true }
            vim.keymap.set("n", "K", function()
              vim.cmd.RustLsp({ "hover", "actions" })
            end, opts)
            vim.keymap.set("n", "<Leader>ca", function()
              vim.cmd.RustLsp("codeAction")
            end, opts)
          end,
          settings = {
            ["rust-analyzer"] = {
              -- checkOnSave must be a boolean; command lives under `check` now.
              -- See docs/troubleshooting/rust-anaylzer-checkonsave-warning.md
              checkOnSave = true,
              check = {
                command = "clippy",
              },
              inlayHints = {
                bindingModeHints = { enable = true },
                closureReturnTypeHints = { enable = true },
                lifetimeElisionHints = { enable = true, useParameterNames = true },
                reborrowHints = { enable = true },
              },
            },
          },
        },
        dap = {
          adapter = {
            type = "executable",
            command = "lldb-vscode",
            name = "rt_lldb",
          },
        },
      }
    end,
  },

  -- Crates.io integration for Cargo.toml files
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("crates").setup({
        null_ls = {
          enabled = true,
          name = "crates.nvim",
        },
        popup = {
          border = "rounded",
        },
      })
    end,
  },
}