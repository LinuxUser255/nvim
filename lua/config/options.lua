-- [[ Setting options ]]
vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

-- highlight current line
vim.opt.cursorline = true

-- display vertical line column at 80
vim.opt.colorcolumn = "80"

-- Clipboard configuration
-- Leave unset for separate registers, or use "unnamed,unnamedplus" for full integration
vim.opt.clipboard = ""  -- Empty means separate registers

-- This gives you:
-- yy/p for internal yanking/pasting (fast, works within nvim)
-- <leader>y/<leader>p for system clipboard operations
