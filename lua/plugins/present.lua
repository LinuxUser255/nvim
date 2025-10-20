return {
  "tjdevries/present.nvim",
  ft = { "markdown" }, -- Only load for markdown files
  cmd = { "PresentStart" }, -- Also load when command is used
  config = function()
    require("present").setup({
      -- Presentation options
      default_mappings = true,
      
      -- Syntax configuration
      syntax = {
        stop = "<!-- stop -->", -- Slide separator
        comment = "%%", -- Comment lines
      },
      
      -- Code execution configuration
      executors = {
        lua = {
          command = "lua",
          args = {},
        },
        python = {
          command = "python3",
          args = {},
        },
        bash = {
          command = "bash",
          args = {},
        },
        javascript = {
          command = "node",
          args = {},
        },
        rust = {
          command = "rust-script",
          args = {},
        },
      },
      
      -- Window configuration
      windows = {
        width = 0.8, -- 80% of screen width
        height = 0.8, -- 80% of screen height
      },
    })
    
    -- Custom keymaps for presentations
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function()
        local opts = { buffer = true, noremap = true, silent = true }
        -- Start presentation
        vim.keymap.set("n", "<leader>ps", "<cmd>PresentStart<CR>", 
          vim.tbl_extend("force", opts, { desc = "Start presentation" }))
        
        -- Navigation (these work during presentation)
        vim.keymap.set("n", "n", function()
          if vim.g.presenting then
            require("present").next()
          end
        end, vim.tbl_extend("force", opts, { desc = "Next slide" }))
        
        vim.keymap.set("n", "p", function()
          if vim.g.presenting then
            require("present").prev()
          end
        end, vim.tbl_extend("force", opts, { desc = "Previous slide" }))
        
        -- Stop presentation
        vim.keymap.set("n", "q", function()
          if vim.g.presenting then
            require("present").stop()
          end
        end, vim.tbl_extend("force", opts, { desc = "Stop presentation" }))
      end,
    })
  end,
}