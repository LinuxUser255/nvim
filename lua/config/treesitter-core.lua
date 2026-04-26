-- NEW FILE for Neovim 0.12.2-dev
-- Location: lua/config/treesitter-core.lua
-- This file enables NATIVE core vim.treesitter highlighting (the modern 0.12 way)
-- It replaces the old "highlight = { enable = true }" from the plugin
-- This is what actually fixes the "attempt to call method 'range' (a nil value)" error

-- Core Neovim 0.12 TreeSitter highlighting
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "markdown", "bash", "sh", "python", "go", "rust",
    "lua", "json", "yaml", "toml", "dockerfile", "solidity",
    "vim", "help", "html", "css", "javascript", "typescript",
    "vue", "svelte", "c", "regex", "*"
  },
  callback = function(ev)
    -- Start native TreeSitter highlighter (this is the 0.12 way)
    pcall(vim.treesitter.start, ev.buf)
  end,
  desc = "Enable core vim.treesitter highlighting for 0.12+ (fixes range nil error)",
})
