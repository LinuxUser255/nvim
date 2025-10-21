# Catppuccin (catppuccin/nvim)

What it is
- Aesthetic theme with multiple flavours (latte, frappe, macchiato, mocha).

Use cases
- Beautiful, readable UI across plugins with integrated highlights.

Usage
- :colorscheme catppuccin (mocha by default in this config)
- Variants: :colorscheme catppuccin-latte | -frappe | -macchiato | catppuccin
- Or use :Color to pick interactively.

Modify
- lua/plugins/colors.lua → require('catppuccin').setup({ ... }) for flavour, styles, integrations.
