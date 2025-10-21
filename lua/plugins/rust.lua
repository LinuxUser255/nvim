return {
  -- Rust-specific plugin with enhanced features
  {
    "simrat39/rust-tools.nvim",
    -- Remove ft restriction and use event instead
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
    },
    config = function()
      local rt = require("rust-tools")

      -- Disable inlay hints to avoid the index out of bounds error
      -- The rust-tools plugin has a bug with buffer line access

      rt.setup({
        server = {
          on_attach = function(_client, bufnr)
            -- Inlay hints disabled due to index out of bounds error
            -- rt.inlay_hints.enable()
          end,
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = {
                enable = true,
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
      })

      -- Set up rust-specific keymaps and indentation for rust files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "rust",
        callback = function(ev)
          local bufnr = ev.buf
          local opts = { buffer = bufnr, noremap = true, silent = true }
          
          -- Keymaps
          vim.keymap.set("n", "K", rt.hover_actions.hover_actions, opts)
          vim.keymap.set("n", "<Leader>ca", rt.code_action_group.code_action_group, opts)
          
          -- Force proper indentation settings for Rust files
          vim.bo[bufnr].tabstop = 4
          vim.bo[bufnr].shiftwidth = 4
          vim.bo[bufnr].softtabstop = 4
          vim.bo[bufnr].expandtab = true
          vim.bo[bufnr].autoindent = true
          vim.bo[bufnr].smartindent = true
          -- Don't use cindent as it conflicts with smartindent/treesitter
          vim.bo[bufnr].cindent = false
        end
      })
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