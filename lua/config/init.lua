-- This init.lua is responsible for lazy.nvim
-- Leader keys already set in globals.lua, no need to duplicate

-- load the lazy pluging manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end

-- Add lazy to the Runtime Path:$XDG_CONFIG_HOME/nvim
-- run the command :help 'runtimepath' for more info
vim.opt.rtp:prepend(lazypath)

-- Pulling the options, globals and keymap lua config files
require('config.options')
require("config.globals")
require('config.keymaps')

-- Invoke lazy, and separate the responsiblity of plugins
-- Instruct lazy to look in the 'plugins' directory
require('lazy').setup('plugins')
