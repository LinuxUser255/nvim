# go.nvim (ray-x/go.nvim)

What it is
- Go development plugin integrating LSP, formatting, code lens, tests, and DAP.

Use cases
- Go-specific tools: imports, formatting, inlay hints, testing, debugging.

Commands/Usage
- Most features are integrated automatically (via gopls). Use LSP keymaps; use :GoTest if configured; DAP via nvim-dap.

Modify
- Edit lua/plugins/golang.lua for formatter (golines), max_line_len, inlay hints, and LSP options.

Dependencies
- ray-x/guihua.lua, nvim-lspconfig, nvim-treesitter, nvim-dap
