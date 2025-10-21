# cmp-tabnine (tzachar/cmp-tabnine)

What it is
- nvim-cmp source for Tabnine suggestions.

Use cases
- Show Tabnine completions alongside LSP and snippets.

Behavior
- Auto-registers Tabnine as an nvim-cmp source on startup (delayed to ensure cmp is loaded).

Modify
- Edit lua/plugins/cmp-tabnine.lua to adjust Tabnine config (max_lines, results, run_on_every_keystroke, show_prediction_strength) and when the source is added to cmp.

Dependencies
- hrsh7th/nvim-cmp, codota/tabnine-nvim
