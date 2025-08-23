
-- LSP Inlay Hints Configuration
local M = {}

function M.setup()
  -- Check Neovim version compatibility
  if not vim.lsp.inlay_hint then
    vim.notify("Inlay hints not supported in this Neovim version", vim.log.levels.WARN)
    return
  end

  -- Create autocmd for enabling inlay hints
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('lsp-inlay-hints', { clear = true }),
    callback = function(event)
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client.server_capabilities.inlayHintProvider then
        -- Enable inlay hints for the buffer (no arguments needed)
        vim.lsp.inlay_hint.enable()

        -- Optional: Add a keymap to toggle inlay hints
        vim.keymap.set('n', '<leader>th', function()
          local current = vim.lsp.inlay_hint.is_enabled()
          if current then
            vim.lsp.inlay_hint.disable()
          else
            vim.lsp.inlay_hint.enable()
          end
        end, { buffer = event.buf, desc = 'Toggle inlay hints' })
      end
    end,
  })
end

-- Function to toggle inlay hints globally
function M.toggle_global()
  if vim.lsp.inlay_hint then
    local current_setting = vim.lsp.inlay_hint.is_enabled()
    if current_setting then
      vim.lsp.inlay_hint.disable()
      vim.notify("Inlay hints disabled", vim.log.levels.INFO)
    else
      vim.lsp.inlay_hint.enable()
      vim.notify("Inlay hints enabled", vim.log.levels.INFO)
    end
  end
end

return M

