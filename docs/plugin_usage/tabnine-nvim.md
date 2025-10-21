# Tabnine (codota/tabnine-nvim)

What it is
- AI code completion engine integrated with nvim-cmp and Tabnine Chat.

Use cases
- AI-assisted suggestions, chat-driven edits/explanations/tests.

Key bindings
- <leader>tc: Open Tabnine Chat (normal/visual)
- <leader>th: Tabnine Hub
- <leader>tl: Tabnine Login
- <leader>ts: Tabnine Status
- <leader>tt: Toggle Tabnine
- <leader>tn: Next suggestion
- <leader>tw: Edit with Tabnine
- <leader>tf: Fix with Tabnine
- <leader>te: Explain code with Tabnine
- <leader>td: Document code with Tabnine
- <leader>tg: Generate test with Tabnine

Notes
- Accept keymap is <Tab> via nvim-cmp; suggestions also appear in completion menu.

Modify
- Edit lua/plugins/tabnine.lua to adjust debounce, keymaps, chat enablement, and source registration with nvim-cmp.
