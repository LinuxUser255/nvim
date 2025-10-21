return {
  "folke/which-key.nvim",
  enabled = false,  -- DISABLED: was interfering with yank/paste operations
  event = "VeryLazy",
  opts = {
    preset = "modern", -- "classic", "modern", or "helix"
    delay = 500, -- increased delay to avoid interfering with normal operations
    filter = function(mapping)
      -- example to exclude mappings without a description
      return mapping.desc and mapping.desc ~= ""
    end,
    spec = {}, -- configure custom key mapping groups
    notify = true, -- show a warning when issues were detected with your mappings
    triggers = {
      { "<leader>", mode = "nxsov" }, -- Only show for leader key combos
    },
    plugins = {
      marks = true, -- shows a list of your marks on ' and `
      registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
      spelling = {
        enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
        suggestions = 20, -- how many suggestions should be shown in the list?
      },
      presets = {
        operators = false, -- DISABLED: was intercepting y, d, c operations
        motions = true, -- adds help for motions
        text_objects = true, -- help for text objects triggered after entering an operator
        windows = true, -- default bindings on <c-w>
        nav = true, -- misc bindings to work with windows
        z = true, -- bindings for folds, spelling and others prefixed with z
        g = true, -- bindings for prefixed with g
      },
    },
    win = {
      border = "rounded", -- none, single, double, shadow, rounded
      padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
      title = true,
      title_pos = "center",
      zindex = 1000,
    },
    layout = {
      width = { min = 20, max = 50 }, -- min and max width of the columns
      spacing = 3, -- spacing between columns
      align = "left", -- align columns left, center or right
    },
    show_help = true, -- show a help message in the command line for using WhichKey
    show_keys = true, -- show the currently pressed key and its label as a message in the command line
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    
    -- Document existing key chains
    wk.add({
      { "<leader>f", group = "Find/File" },
      { "<leader>g", group = "Git" },
      { "<leader>l", group = "LSP" },
      { "<leader>s", group = "Search" },
      { "<leader>t", group = "Toggle" },
      { "<leader>w", group = "Window" },
      { "<leader>b", group = "Buffer" },
      { "<leader>c", group = "Code" },
    })
  end,
}
