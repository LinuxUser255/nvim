-- This init.lua is responsible for lazy.nvim
-- The pwd for this file ~./config/nvim/lua/config/init.lua
-- Configuration template: https://lazy.folke.io/configuration
-- Check for path where lazy is to be installed
-- Set the leaderkey to spacebar
vim.g.maplocalleader = ' '
vim.g.mapleader = ' '
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
vim.opt.rtp:prepend(lazypath)


require('config.options')
require("config.globals")
require('config.keymaps')

local plugins = "plugins"

local opts = {
	defaults = {
		lazy = true,
	},
	install = {
		colorscheme = { "rose-pine" },
	},
}

-- Need to invoke lazy, and separate the responsiblity of plugins
-- Instruct lazy to look in the 'plugins' directory
require('lazy').setup('plugins')
