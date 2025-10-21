# LuaSnip (L3MON4D3/LuaSnip)

What it is
- Snippet engine for Neovim.

Use cases
- Expand snippets in completion and via keymaps; used by nvim-cmp in this config.

Usage
- Snippets from friendly-snippets (if installed) can be loaded; this config loads VSCode-style snippets via loaders.

Modify
- See lua/plugins/lsp.lua where LuaSnip is integrated with nvim-cmp; customize snippets or loaders as needed.