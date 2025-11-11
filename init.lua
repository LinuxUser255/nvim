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

-- macOS branch: Patch nvim-cmp for Neovim 0.11 compatibility
local original_require = require
_G.require = function(modname)
  local result = original_require(modname)
  
  -- Apply patches after modules are loaded
  if modname == 'cmp.utils.api' then
    local api = result
    if api.get_cursor and not api._patched then
      local original_get_cursor = api.get_cursor
      api.get_cursor = function()
        local cursor = original_get_cursor()
        return {
          tonumber(cursor[1]) or 1,
          tonumber(cursor[2]) or 0
        }
      end
      api._patched = true
    end
  elseif modname == 'cmp.utils.misc' then
    local misc = result
    if misc.to_utfindex and not misc._patched then
      local original_to_utfindex = misc.to_utfindex
      misc.to_utfindex = function(text, vimindex)
        if type(vimindex) == 'string' then
          vimindex = tonumber(vimindex)
        end
        return original_to_utfindex(text, vimindex)
      end
      misc._patched = true
    end
  end
  
  return result
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
