# todo-comments (folke/todo-comments.nvim)

What it is
- Highlights and searches for TODO, FIX, HACK, WARN, NOTE, etc., across your code.

Use cases
- Track and navigate annotations; search TODOs via Telescope.

Key bindings
- ]t / [t: Jump to next/previous TODO comment
- <leader>ft: Open TodoTelescope (note: overrides "Treesitter" mapping in global keymaps)

Modify
- Edit lua/plugins/todo-comments.lua to adjust keywords, colors, highlight styles, and ripgrep options.

Dependencies
- nvim-lua/plenary.nvim
- Telescope for :TodoTelescope integration
