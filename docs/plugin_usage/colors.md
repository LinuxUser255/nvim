# Colorschemes and Theme Selector

Included themes
- Catppuccin (catppuccin/nvim)
- TokyoNight (folke/tokyonight.nvim)
- Rose Pine (rose-pine/neovim)

Default
- Currently set to: rose-pine

Theme switcher
- Command: :Color (opens a Telescope picker with curated theme variants)
- Key: <leader>ct — Change Theme

Modify
- Edit lua/plugins/colors.lua to change the default colorscheme, tweak theme options, or the list presented by :Color.

Dependencies
- nvim-telescope/telescope.nvim (for the picker)
- rcarriga/nvim-notify (for on-screen notifications)
