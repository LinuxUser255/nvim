-- Rust-specific indentation settings
-- This file ensures proper 4-space indentation for Rust files

-- Basic indentation settings (4 spaces)
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4
vim.bo.expandtab = true

-- Enable auto indentation but not cindent (to avoid conflicts)
vim.bo.autoindent = true
vim.bo.smartindent = true
vim.bo.cindent = false

-- Use treesitter for indentation when available
local has_treesitter, _ = pcall(require, "nvim-treesitter.configs")
if has_treesitter then
  -- Let treesitter handle the indentation
  vim.bo.indentexpr = "nvim_treesitter#indent()"
  -- Disable smartindent when using treesitter to avoid conflicts
  vim.bo.smartindent = false
end

-- Additional Rust-specific settings
vim.bo.comments = "s0:/*!,m:*,ex:*/,s1:/*,mb:*,ex:*/,:///,://"
vim.bo.commentstring = "// %s"

-- Ensure we're not duplicating indents
vim.bo.copyindent = false
vim.bo.preserveindent = false
