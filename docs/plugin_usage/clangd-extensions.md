# clangd_extensions (p00f/clangd_extensions.nvim)

What it is
- Enhancements for clangd LSP: inlay hints, AST, memory usage, symbol info.

Use cases
- Better C/C++ development experience with clangd.

Key bindings
- Uses LSP keymaps from lspconfig.md; inlay hints enabled automatically per config.

Modify
- Edit lua/plugins/cpp.lua (first spec) to adjust server cmd flags and extensions (inlay hints, AST UI, etc.).

Dependencies
- neovim/nvim-lspconfig, hrsh7th/cmp-nvim-lsp
