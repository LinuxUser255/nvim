return {
  -- Tokyo Night
  'folke/tokyonight.nvim',
  priority = 1000,
  config = function()
    vim.cmd.colorscheme 'tokyonight-night'
    -- vim.cmd.colorscheme 'rose-pine' -- Uncomment to activate rose-pine

    -- Catppuccin Base https://catppuccin.com/palette
    vim.api.nvim_set_hl(0, "Normal", { bg = "#1e1e2e"})
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e1e2e"})

    -- Transparent Background
    -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  end,
}