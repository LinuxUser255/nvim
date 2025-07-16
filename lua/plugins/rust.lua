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

      -- Check if using a version of rust-tools in need of  patching
      local function patch_rust_tools()
        -- Patch the inlay_hints.lua file to use newer API methods
        local inlay_hints = require("rust-tools.inlay_hints")

        -- Backup the original functions if not already patched
        if not inlay_hints._original_set_inlay_hints then
          inlay_hints._original_set_inlay_hints = inlay_hints.set_inlay_hints

          -- Override the function with a version that uses the new API
          inlay_hints.set_inlay_hints = function(bufnr, opts)
            -- Use vim.lsp.get_clients() instead of vim.lsp.get_active_clients()
            local clients = vim.lsp.get_clients({
              bufnr = bufnr,
              name = "rust_analyzer",
            })

            for _, client in ipairs(clients) do
              -- Use client:request instead of client.request
              client:request(
                'textDocument/inlayHint',
                vim.lsp.util.make_text_document_params(bufnr),
                function(err, result, ctx)
                  -- Rest of the handler remains the same
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

      -- Apply the patch before setting up rust-tools
      patch_rust_tools()

      -- Setup rust-tools with your configuration
      rt.setup({
        server = {
          on_attach = function(_client, bufnr)
            -- Enable inlay hints
            rt.inlay_hints.enable()

            -- Add your keymaps and other on_attach functionality here
            local opts = { buffer = bufnr, noremap = true, silent = true }
            vim.keymap.set("n", "K", rt.hover_actions.hover_actions, opts)
            vim.keymap.set("n", "<Leader>ca", rt.code_action_group.code_action_group, opts)
          end,
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = {
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
        -- DAP configuration
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
