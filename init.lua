-- init.lua
-- Neovim 0.12.2-dev Configuration Entry Point
-- Structured like main.py or Bash main() pattern design pattern

-- ============================================
-- 1. HELPER / SETUP FUNCTIONS
-- ============================================

local function setup_early_suppressors()
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

  -- Suppress Tabnine Node.js 403 update error spam (cosmetic)
  vim.notify = (function(original_notify)
    return function(msg, ...)
      if type(msg) == "string" and (
        msg:match("Failed to ensure Node runtime") or
        msg:match("status code 403") or
        msg:match("Node installer failed")
      ) then
        return
      end
      return original_notify(msg, ...)
    end
  end)(vim.notify)
end

local function setup_autocommands()
  -- Suppress go.nvim message without requiring diagnostics again
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      local diagnostics = require("config.diagnostics")
      diagnostics.suppress_by_message("max_line_len only effective when gofmt is golines")
    end,
    group = vim.api.nvim_create_augroup("SuppressGoNvimMessage", { clear = true }),
    desc = "Suppress go.nvim max_line_len message on startup",
  })
end

-- ============================================
-- 2. MAIN FUNCTION (like main() in Bash/Python)
-- ============================================

local function main()
  setup_early_suppressors()
  require('config')
  require('config.commands')
  require('config.disable-inlay-hints')
  setup_autocommands()
end

-- ============================================
-- 3. CALL MAIN at the bottom just like other programming languages
-- ============================================

main()
