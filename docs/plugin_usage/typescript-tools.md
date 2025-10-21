# typescript-tools.nvim (pmizio/typescript-tools.nvim)

What it is
- Enhanced TypeScript/JavaScript LSP client with extra code actions and commands.

Use cases
- Organize imports, fix all, remove unused, add missing imports, rename file, go to source definition.

Key bindings (in TS/JS buffers)
- <leader>toi: Organize imports
- <leader>tru: Remove unused
- <leader>tfi: Fix all
- <leader>tai: Add missing imports
- <leader>tsu: Sort imports
- <leader>trf: Rename file
- <leader>tgd: Go to source definition

Modify
- Edit lua/plugins/typescript.lua to adjust settings and keymaps.

Dependencies
- plenary.nvim, nvim-lspconfig
