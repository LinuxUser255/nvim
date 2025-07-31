return {
  -- Create a local plugin
  dir = vim.fn.stdpath("config") .. "/lua/custom/tabnine-chat",
  name = "tabnine-chat-extension",

  -- This is an extension to the main tabnine-nvim plugin
  dependencies = {
    'codota/tabnine-nvim',
  },

  config = function()
    -- Load the custom Tabnine chat extension
    local tabnine_chat = require("custom.tabnine-chat")

    -- Create a command to toggle font size for Tabnine Chat
    -- Define this command first to ensure it's available globally
    vim.api.nvim_create_user_command('TabnineChatFontSize', function(opts)
      local size = tonumber(opts.args)
      if size and size > 0 then
        if vim.g.neovide then
          -- Extract current font name and update only the size
          local current_font = vim.o.guifont
          local font_name = current_font:match("(.+):h%d+")
          if font_name then
            vim.opt.guifont = font_name .. ":h" .. size
          else
            vim.opt.guifont = "JetBrainsMono Nerd Font:h" .. size
          end
          print("Tabnine Chat font size set to " .. size)
        else
          print("Font size adjustment only works in GUI Neovim like Neovide")
        end
      else
        print("Please provide a valid font size (e.g., TabnineChatFontSize 16)")
      end
    end, { nargs = 1, desc = "Set font size for Tabnine Chat" })

    -- Add a keybinding for quick access to the font size command
    vim.keymap.set("n", "<leader>tcf", ":TabnineChatFontSize ", { desc = "Set Tabnine Chat font size", silent = false })

    -- Configure the appearance of Tabnine Chat window
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "tabnine-chat",
      callback = function(ev)
        local buf = ev.buf
        local win = vim.fn.bufwinid(buf)
        
        if win == -1 then
          return  -- Window not found
        end

        -- Make window opaque
        vim.api.nvim_win_set_option(win, "winblend", 0)

        -- Set a larger window size for better readability
        vim.api.nvim_win_set_height(win, math.floor(vim.o.lines * 0.7))
        vim.api.nvim_win_set_width(win, math.floor(vim.o.columns * 0.7))

        -- If using Neovide or another GUI that supports per-window options
        if vim.g.neovide then
          -- Store the original global font setting
          if not vim.g.original_guifont then
            vim.g.original_guifont = vim.o.guifont
          end

          -- Use a monospace font with increased size
          -- Replace with your preferred font
          vim.opt.guifont = "JetBrainsMono Nerd Font:h14"

          -- Restore original font when leaving the buffer
          vim.api.nvim_create_autocmd("BufLeave", {
            buffer = buf,
            callback = function()
              if vim.g.original_guifont then
                vim.opt.guifont = vim.g.original_guifont
              end
            end,
            once = true
          })
        end

        -- Additional styling for the chat window
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.breakindent = true

        -- Increase the text contrast for better readability
        vim.api.nvim_set_hl(0, "TabnineChatText", { fg = "#ffffff", bold = true })
        vim.cmd("highlight! link Normal TabnineChatText")
      end
    })

    -- Print a message to confirm the plugin is loaded and commands are registered
    vim.schedule(function()
      print("Tabnine Chat Extension loaded. Use :TabnineChatFontSize <size> to adjust font size.")
    end)
  end,

  -- Ensure this plugin is loaded after tabnine-nvim
  event = "VeryLazy",
}