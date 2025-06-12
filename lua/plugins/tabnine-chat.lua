return {
  -- Create a local plugin
  dir = vim.fn.stdpath("config") .. "/lua/custom/tabnine-chat",
  name = "tabnine-chat-extension",

  -- This is an extension to the main tabnine-nvim plugin
  dependencies = {
    'codota/tabnine-nvim',
  },

  -- No need for config function here as it's in the init.lua file
  -- of the local plugin directory
}