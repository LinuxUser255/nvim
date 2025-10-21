# Telescope (nvim-telescope/telescope.nvim)

What it is
- Fuzzy finder for files, buffers, help, symbols, git, etc.

Use cases
- Quickly locate files, grep text, browse buffers, search help, and more.

Key bindings (from plugin + global keymaps)
- <leader>pf: Find files (builtin.find_files)
- <C-p>: Git files
- <leader>pws / <leader>pWs: Grep cword / cWORD
- <leader>ps: Grep with prompt
- <leader>vh: Help tags
- <leader>tt: Open Telescope
- <leader>ff: Find files
- <leader>fg: Live grep
- <leader>/: Fuzzy find in current buffer
- <leader>fb: Buffers
- <leader>ft: Treesitter symbols (note: may be overridden by todo-comments mapping)
- <leader>fo: Old files
- <leader>fs: Grep string
- <leader>fc: Git commits
- <leader>fh: Help
- <leader>fj: Command history
- <leader>fk: Keymaps
- <leader>fl: LSP references (note: Harpoon maps <leader>fl to its list)

Commands/Usage
- Use the key bindings above to open pickers. Inside Telescope, use <C-j>/<C-k> or arrows to move, <CR> to select.

Modify
- Edit lua/plugins/telescope.lua to change default setup and built-in mappings.
- Global keybindings are in lua/config/keymaps.lua.

Dependencies
- nvim-lua/plenary.nvim
