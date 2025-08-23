
-- Completely disable inlay hints
vim.lsp.inlay_hint.enable(false)

-- Only set handler if it hasn't been set already
if not vim.lsp.handlers['textDocument/inlayHint'] then
  vim.lsp.handlers['textDocument/inlayHint'] = function() end
end

-- Override the enable function to prevent any future enabling
local original_enable = vim.lsp.inlay_hint.enable
vim.lsp.inlay_hint.enable = function()
  -- Do nothing - completely disable
  return false
end

