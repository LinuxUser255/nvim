-- Patched for Neovim 0.12.2-dev (FINAL VERSION)
-- Location: lua/plugins/nvim-treesitter.lua
-- Uses new main branch API (no more .configs submodule)

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  lazy = false,
  config = function()
    require("nvim-treesitter").setup({
      ensure_installed = {
        "vim", "lua", "python", "go", "rust", "markdown",
        "bash", "json", "yaml", "toml", "dockerfile",
        "solidity", "gitignore", "html", "css", "javascript",
        "typescript", "vue", "svelte", "c", "regex"
      },
      auto_install = true,
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-s>",
          node_incremental = "<C-s>",
          node_decremental = "<BS>",
        },
      },
    })
  end,
}
