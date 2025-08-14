-- LSP inlay hint error fix
local function patch_inlay_hints()
  local original_handler = vim.lsp.handlers['textDocument/inlayHint']

  vim.lsp.handlers['textDocument/inlayHint'] = function(err, result, ctx, config)
    if err then
      return
    end

    -- Safely handle the inlay hints
    local ok, error_msg = pcall(function()
      if original_handler then
        return original_handler(err, result, ctx, config)
      end
    end)

    if not ok then
      -- Silently ignore inlay hint errors to prevent spam
      vim.schedule(function()
        vim.notify("Inlay hint error (silenced): " .. tostring(error_msg), vim.log.levels.DEBUG)
      end)
    end
  end
end

-- Apply the patch
patch_inlay_hints()

return {}

