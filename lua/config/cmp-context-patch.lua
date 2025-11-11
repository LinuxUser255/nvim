-- macOS branch: Patch for nvim-cmp on Neovim 0.11
-- Fixes compatibility issues with cursor position handling

local M = {}

function M.patch()
  -- Override the API get_cursor function to ensure correct types
  local api = require('cmp.utils.api')
  local original_get_cursor = api.get_cursor
  
  api.get_cursor = function()
    local cursor = original_get_cursor()
    -- Ensure both values are numbers
    return {
      tonumber(cursor[1]) or 1,
      tonumber(cursor[2]) or 0
    }
  end
  
  -- Also patch misc.to_utfindex to handle type conversion
  local misc = require('cmp.utils.misc')
  local original_to_utfindex = misc.to_utfindex
  
  misc.to_utfindex = function(text, vimindex)
    -- Ensure vimindex is a number
    if type(vimindex) == 'string' then
      vimindex = tonumber(vimindex)
    end
    return original_to_utfindex(text, vimindex)
  end
end

return M
