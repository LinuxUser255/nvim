return {
  "tjdevries/express_line.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = "VeryLazy",
  config = function()
    -- Use a global statusline and hide default mode display since statusline shows it
    vim.o.laststatus = 3
    vim.o.showmode = false

    -- Minimal setup; express_line provides a default generator
    require("el").setup({})
  end,
}
