-- This init.lua is to fuction as an entry point for my configuration.
-- Neovim runtime path, (rtp) looks for this entrypoint: init.lua
-- located: $XDG_CONFIG_HOME/nvim/init.lua
require('config')
require('tabnine').setup({
  disable_auto_comment=true,
  accept_keymap="<Tab>",
  dismiss_keymap = "<C-]>",
  debounce_ms = 800,
  suggestion_color = {gui = "#808080", cterm = 244},
  exclude_filetypes = {"TelescopePrompt"}
})
