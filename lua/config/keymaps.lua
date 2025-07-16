-- This keymaps file needs to be "required" in /nvim/config/init.lua

-- [[ Useful Remaps ]]

--  [[ Project View & Vertical Splits ]]

--   leader pv enters Project View, ( netrw's version of a file tree)
--   leader ve splits the screen in two, verticaly

-- [[ Vertical window navigation ]]
--  Ctrl l jumps to the Right window
--  Ctrl h jumps to the Left window

-- [[ Window Resizing ]]
--  Increase width by 3 columns: Ctrl o
--  Decrease width by 3 columns: Ctrl y

-- [[ Moving lines up and down ]]
--  when highlighting a line, press shift + j or k
--  visual shif K to move up, and
--  visual shift J to move down

-- ! Extremely useful:
--  space + s opens a menu
--  and begins replacing the word on which your cursor lies.

-- [[ Copy Pasting ]]
--  leader y
--  or leader capital Y

-- [[ Telescope cmds ]]
-- leader tt    opens telescope
-- leader ff    finds files
-- leader fg    live grep
-- leader /     fuzzy find in current buffer

-- [[ NetRW cmds Project view, vertical & horizontal window split ]]
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>ve", vim.cmd.Vex)
vim.keymap.set("n", "<leader>he", vim.cmd.Sex)

-- [[ Vertical split window navigation ]]
-- Remap Ctrl + l to move to the right split window
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to the right split window" })

-- Remap Ctrl + h to move to the left split window
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to the left split window" })

-- Increase width by 3 columns: Ctrl o
vim.keymap.set("n", "<C-o>", "<C-w>3>", { desc = "Increase vertical width by 3 columns" })

-- Decrease width by 3 columns: Ctrl y
vim.keymap.set("n", "<C-y>", "<C-w>3<", { desc = "Decrease vertical width by 3 columns" })

-- Make the file executable without having to exit and chmoding it manually.
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

--[ ! Move an entite line or lines up or down. ]]
-- when highlighting a line, press shift + j or k
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

-- J takes the line below and appends it to your current line with a space
-- And this one keeps your cursor in one place dispite movving other lines
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "J", "mzJ`z")

-- The two below keeps the cursor in the middle when scrolling with ctrl + d & u
-- Makes searching the file less disorienting.
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Make search terms stay in the middle when searching the file for characters, text, etc..
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Pasting highlighted text over a pre-selected highligted text
-- Deletes highlighted word into the 'void' register and then paste it over.
vim.keymap.set("x", "<leader>p", [["_dP]])

-- YANK TEXT TO THE SYSTEM CLIPBOARD, leader y enabling you to paste elsewhere
-- 1st way: Select the line(s): Normal mode, ctrl v to select the line, then leader y
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
-- 2nd way: Normal mode, then shift + leader + y
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])
vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("n", "Q", "<nop>")

-- When using Tmux: ctrl + f and now fuzzy find in another terminal session
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- Quick-fix navigation list
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- ! Extremely useful: space + s opens a menu and begin replacing the word on which your cursor lies.
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Telescope keymaps
vim.keymap.set("n", "<leader>tt", vim.cmd.Telescope, { desc = "Open Telescope" })
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find All Files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live Grep (Ripgrep)" })
vim.keymap.set("n", "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Buffer search" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
vim.keymap.set("n", "<leader>ft", "<cmd>Telescope treesitter<cr>", { desc = "Treesitter" })
vim.keymap.set("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "Old Files" })
vim.keymap.set("n", "<leader>fs", "<cmd>Telescope grep_string<cr>", { desc = "Grep Strg" })
vim.keymap.set("n", "<leader>fc", "<cmd>Telescope git_commits<cr>", { desc = "Commits" })

vim.keymap.set("n", "<C-p>", "<cmd>Telescope git_files<cr>", { desc = "Git files" })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help" })
vim.keymap.set("n", "<leader>fj", "<cmd>Telescope command_history<cr>", { desc = "Command History" })
vim.keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Keymaps" })
vim.keymap.set("n", "<leader>fl", "<cmd>Telescope lsp_references<cr>", { desc = "LSP References" })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- ThePrimeagen's Flashy Highlight on yank
local augroup = vim.api.nvim_create_augroup
local ThePrimeagenGroup = augroup('ThePrimeagen', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
    require("plenary.reload").reload_module(name)
end

-- Create a custom highlight group for yank highlighting
local set_yank_highlight = function()
    vim.api.nvim_set_hl(0, 'YankHighlight', { bg = '#FBDE84', fg = '#000000', bold = true })
end

-- Set it now
set_yank_highlight()

-- And also set it whenever the colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = set_yank_highlight,
})

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'YankHighlight',
            timeout = 40,
        })
    end,
})

autocmd({ "BufWritePre" }, {
    group = ThePrimeagenGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

-- attempt opaque background: It worked!
--vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
--vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
