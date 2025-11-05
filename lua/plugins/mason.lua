return {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'j-hui/fidget.nvim',
    'folke/neodev.nvim',
    'hrsh7th/nvim-cmp', -- Autocompletion

    -- Snippet Engine & its associated nvim-cmp source
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'rafamadriz/friendly-snippets',

    -- Adds LSP completion capabilities
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',       -- Optional
    'hrsh7th/cmp-path',         -- Optional
    'saadparwaiz1/cmp_luasnip', -- Optional

    -- Adds a number of user-friendly snippets
    'rafamadriz/friendly-snippets',
    --TabNine, AI Autocompletion
    'codota/tabnine-nvim', build = "./dl_binaries.sh" ,

    cmd = 'Mason',
    event = 'BufReadPre',
    config = true

}


