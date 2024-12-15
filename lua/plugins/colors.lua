return
  {
    -- Rose Pine theme
    -- 'rose-pine/neovim', Uncomment to use Rose Pine
    -- Tokyo Night
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'tokyonight-night'
    -- vim.cmd.colorscheme 'rose-pine' -- Uncomment to activate rose-pine
      require('mason-lspconfig').setup()

            vim.api.nvim_set_hl(0, "Normal", { bg = "#1e1e2e"}) -- Set background color to a dark gray
            -- vim.api.nvim_set_hl(0, "Normal", { bg = "#2E3436"}) -- Set background color to a dark gray
            --vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#2E3436"}) -- Set background color for normal
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e1e2e"}) -- Set background color for normal
-- float

           -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
           -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    end,
  }
