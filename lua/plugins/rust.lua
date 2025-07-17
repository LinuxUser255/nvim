return {
  -- Rust-specific plugin with enhanced features
  {
    "simrat39/rust-tools.nvim",
    ft = { "rust" },
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
    },
    config = function()
      local rt = require("rust-tools")

      -- Check if using a version of rust-tools in need of patching
      local function patch_rust_tools()
        local inlay_hints = require("rust-tools.inlay_hints")

        if not inlay_hints._original_set_inlay_hints then
          inlay_hints._original_set_inlay_hints = inlay_hints.set_inlay_hints

          inlay_hints.set_inlay_hints = function(bufnr, opts)
            local clients = vim.lsp.get_clients({
              bufnr = bufnr,
              name = "rust_analyzer",
            })

            for _, client in ipairs(clients) do
              client:request(
                'textDocument/inlayHint',
                vim.lsp.util.make_text_document_params(bufnr),
                function(err, result, ctx)
                  if err then
                    vim.notify("Error getting inlay hints: " .. err.message, vim.log.levels.WARN)
                    return
                  end
                  inlay_hints.handler(err, result, ctx, bufnr, opts)
                end,
                bufnr
              )
            end
          end
        end
      end

      patch_rust_tools()

      rt.setup({
        server = {
          on_attach = function(_client, bufnr)
            rt.inlay_hints.enable()
            local opts = { buffer = bufnr, noremap = true, silent = true }
            vim.keymap.set("n", "K", rt.hover_actions.hover_actions, opts)
            vim.keymap.set("n", "<Leader>ca", rt.code_action_group.code_action_group, opts)
          end,
          settings = {
            ["rust-analyzer"] = {
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

