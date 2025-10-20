return {
  'akinsho/toggleterm.nvim',
  version = "*",
  opts = {
    size = function(term)
      if term.direction == "horizontal" then
        return 15
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
    open_mapping = [[<c-\>]], -- Toggle terminal with Ctrl+\
    hide_numbers = true, -- hide the number column in toggleterm buffers
    shade_terminals = true, -- shade terminal background
    shading_factor = 2, -- the degree by which to darken to terminal colour
    start_in_insert = true,
    insert_mappings = true, -- whether or not the open mapping applies in insert mode
    terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
    persist_size = true,
    persist_mode = true, -- if set to true (default) the previous terminal mode will be remembered
    direction = 'float', -- 'vertical' | 'horizontal' | 'tab' | 'float'
    close_on_exit = true, -- close the terminal window when the process exits
    shell = vim.o.shell, -- change the default shell
    auto_scroll = true, -- automatically scroll to the bottom on terminal output
    float_opts = {
      border = 'curved', -- 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
      width = function()
        return math.floor(vim.o.columns * 0.9)
      end,
      height = function()
        return math.floor(vim.o.lines * 0.9)
      end,
      winblend = 3,
    },
    winbar = {
      enabled = false,
      name_formatter = function(term)
        return term.name
      end
    },
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)
    
    -- Set terminal keymaps
    function _G.set_terminal_keymaps()
      local opts = {buffer = 0}
      vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
      vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
      vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
      vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
      vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
    end
    
    vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
    
    -- Custom terminal commands
    local Terminal = require('toggleterm.terminal').Terminal
    
    -- Lazygit terminal
    local lazygit = Terminal:new({
      cmd = "lazygit",
      dir = "git_dir",
      direction = "float",
      float_opts = {
        border = "curved",
      },
      on_open = function(term)
        vim.cmd("startinsert!")
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
      end,
    })
    
    function _LAZYGIT_TOGGLE()
      lazygit:toggle()
    end
    
    -- Python REPL
    local python = Terminal:new({
      cmd = "python3",
      direction = "float",
      hidden = true,
    })
    
    function _PYTHON_TOGGLE()
      python:toggle()
    end
    
    -- Node REPL
    local node = Terminal:new({
      cmd = "node",
      direction = "float",
      hidden = true,
    })
    
    function _NODE_TOGGLE()
      node:toggle()
    end
    
    -- Key mappings
    vim.keymap.set('n', '<leader>tf', '<cmd>ToggleTerm direction=float<cr>', { desc = "Toggle floating terminal" })
    vim.keymap.set('n', '<leader>th', '<cmd>ToggleTerm direction=horizontal<cr>', { desc = "Toggle horizontal terminal" })
    vim.keymap.set('n', '<leader>tv', '<cmd>ToggleTerm direction=vertical<cr>', { desc = "Toggle vertical terminal" })
    vim.keymap.set('n', '<leader>tg', '<cmd>lua _LAZYGIT_TOGGLE()<cr>', { desc = "Toggle lazygit" })
    vim.keymap.set('n', '<leader>tp', '<cmd>lua _PYTHON_TOGGLE()<cr>', { desc = "Toggle Python REPL" })
    vim.keymap.set('n', '<leader>tn', '<cmd>lua _NODE_TOGGLE()<cr>', { desc = "Toggle Node REPL" })
  end,
}
