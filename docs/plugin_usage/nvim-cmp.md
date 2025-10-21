# nvim-cmp (hrsh7th/nvim-cmp)

What it is
- Autocompletion engine integrated with LSP, buffer, path, and Tabnine, with snippet support via LuaSnip and icons via lspkind.

Use cases
- Inline completion suggestions with confirm, navigation, and snippet expansion.

Key bindings (insert mode)
- <C-k>/<C-j>: Previous/next item
- <C-b>/<C-f>: Scroll docs
- <C-Space>: Trigger completion
- <C-e>: Abort
- <CR>: Confirm selection
- <Tab>: Confirm if menu visible; otherwise expand/jump snippet; falls back to Tab
- <S-Tab>: Previous item or jump back in snippet

Modify
- Edit lua/plugins/lsp.lua (second spec) to adjust sources, mappings, formatting, and snippet behavior.

Dependencies
- hrsh7th/cmp-nvim-lsp, hrsh7th/cmp-buffer, hrsh7th/cmp-path, hrsh7th/cmp-cmdline
- L3MON4D3/LuaSnip, saadparwaiz1/cmp_luasnip, onsails/lspkind.nvim
- Tabnine sources configured separately (see tabnine-nvim.md and cmp-tabnine.md)
