-- Suppress lspconfig deprecation warning and stack trace early
local original_notify = vim.notify
local suppress_next_stack = false

vim.notify = function(msg, ...)
  if type(msg) == 'string' then
    if msg:match('lspconfig.*deprecated') or msg:match('Feature will be removed in nvim%-lspconfig') then
      suppress_next_stack = true
      return
    elseif suppress_next_stack and msg:match('stack traceback') then
      return
    elseif not msg:match('stack traceback') then
      suppress_next_stack = false
    end
  end
  return original_notify(msg, ...)
end

require('config')
require('config.commands')
-- Choose ONE inlay hint solution (currently using disable)
require('config.disable-inlay-hints')

-- Suppress go.nvim message without requiring diagnostics again
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local diagnostics = require("config.diagnostics")
    diagnostics.suppress_by_message("max_line_len only effective when gofmt is golines")
  end,
  group = vim.api.nvim_create_augroup("SuppressGoNvimMessage", { clear = true }),
  desc = "Suppress go.nvim max_line_len message on startup",
})
