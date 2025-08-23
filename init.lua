require('config')
require('config.diagnostics')
require('config.commands')
require('config.lsp-inlay-hints-fix')
require('config.disable-inlay-hints')

-- Add this to your init.lua file
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Suppress the specific go.nvim message
    require("config.diagnostics").suppress_by_message("max_line_len only effective when gofmt is golines")
  end,
  group = vim.api.nvim_create_augroup("SuppressGoNvimMessage", { clear = true }),
  desc = "Suppress go.nvim max_line_len message on startup",
})
