-- macOS branch: Fix for nvim-cmp on Neovim 0.11
-- This module wraps nvim-cmp to fix cursor type issues

local M = {}

-- Store original functions
local api_patched = false
local misc_patched = false

-- Apply patches before loading cmp
local function apply_patches()
  -- Patch cmp.utils.api
  if not api_patched then
    local ok_api, api = pcall(require, 'cmp.utils.api')
    if ok_api and api.get_cursor then
      local original_get_cursor = api.get_cursor
      api.get_cursor = function()
        local cursor = original_get_cursor()
        -- Ensure both values are numbers (fix for Neovim 0.11)
        return {
          tonumber(cursor[1]) or 1,
          tonumber(cursor[2]) or 0
        }
      end
      api_patched = true
    end
  end
  
  -- Patch cmp.utils.misc
  if not misc_patched then
    local ok_misc, misc = pcall(require, 'cmp.utils.misc')
    if ok_misc and misc.to_utfindex then
      local original_to_utfindex = misc.to_utfindex
      misc.to_utfindex = function(text, vimindex)
        -- Ensure vimindex is a number
        if type(vimindex) == 'string' then
          vimindex = tonumber(vimindex) or 1
        end
        return original_to_utfindex(text, vimindex)
      end
      misc_patched = true
    end
  end
end

-- Setup function that applies patches and configures nvim-cmp
M.setup = function()
  -- Apply patches first
  apply_patches()
  
  -- Now load and configure nvim-cmp
  local cmp = require('cmp')
  local luasnip = require('luasnip')
  local lspkind = require('lspkind')

  require("luasnip/loaders/from_vscode").lazy_load()

  vim.opt.completeopt = "menu,menuone,noselect"

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
      ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
      ["<C-e>"] = cmp.mapping.abort(), -- close completion window
      ["<CR>"] = cmp.mapping.confirm({ select = false }),
    }),
    -- sources for autocompletion (macOS branch config)
    sources = cmp.config.sources({
      { name = "nvim_lsp", priority = 1000 }, -- lsp
      { name = "cmp_tabnine", priority = 900 }, -- Tabnine AI completions
      { name = "luasnip", priority = 750 }, -- snippets
      { name = "buffer", priority = 500 }, -- text within current buffer
      { name = "path", priority = 250 }, -- file system paths
    }),
    -- configure lspkind for vs-code like icons
    formatting = {
      format = lspkind.cmp_format({
        maxwidth = 50,
        ellipsis_char = "...",
      }),
    },
  })
end

return M