# rust-tools.nvim (simrat39/rust-tools.nvim)

What it is
- Extra tools for Rust LSP (rust-analyzer), including hover actions and code action groups.

Use cases
- Enhanced Rust developer experience and DAP integration.

Key bindings (Rust buffers)
- K: Hover actions (overrides LSP hover in Rust files)
- <Leader>ca: Rust code action group

Modify
- Edit lua/plugins/rust.lua to tweak rust-analyzer settings and dap adapter.

Dependencies
- nvim-lspconfig, plenary.nvim, nvim-dap
