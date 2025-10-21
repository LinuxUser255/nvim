# Tree-sitter (nvim-treesitter/nvim-treesitter)

What it is
- Modern parsing-based syntax highlighting, indentation, and selections.

Use cases
- Better highlighting, text objects, incremental selection, indentation.

Key bindings (from config)
- <C-s>: Start/expand incremental selection
- <BS>: Shrink selection

Commands/Usage
- Parsers auto-install on buffer open when configured. You can manually run :TSInstall <lang> or :TSUpdate.
- Incremental selection: place cursor, press <C-s> repeatedly to expand, <BS> to shrink.

Modify
- Edit lua/plugins/treesitter.lua to adjust ensure_installed, highlighting, indentation, incremental_selection keymaps.

Notes
- ensure_installed includes many languages (lua, python, go, rust, js/ts, html, css, bash, etc.).
