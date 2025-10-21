# Toggleterm (akinsho/toggleterm.nvim)

What it is
- Integrated terminal manager for floating, horizontal, or vertical terminals and custom terminals (e.g., Lazygit, REPLs).

Use cases
- Quickly toggle terminals, run Lazygit, Python/Node REPLs.

Key bindings
- <c-\>: Toggle last terminal
- <leader>tf: Toggle floating terminal
- <leader>th: Toggle horizontal terminal
- <leader>tv: Toggle vertical terminal
- <leader>tg: Toggle Lazygit
- <leader>tp: Toggle Python REPL
- <leader>tn: Toggle Node REPL
- Terminal mode: <esc> or jk exits to normal; <C-h/j/k/l> moves between windows; <C-w> enters window command mode

Modify
- Edit lua/plugins/toggleterm.lua: size, direction, open_mapping, float_opts, and custom Terminal definitions (Lazygit, Python, Node).

Dependencies
- None required beyond Neovim; Lazygit should be installed for that terminal.
