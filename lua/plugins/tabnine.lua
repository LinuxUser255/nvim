return {
  'codota/tabnine-nvim',
  build = "./dl_binaries.sh",
  lazy = false,
  config = function()
    -- Load and configure Tabnine
    require('tabnine').setup({
      disable_auto_comment = true,
      accept_keymap = "<Tab>",
      dismiss_keymap = "<C-]>",
      debounce_ms = 800,
      suggestion_color = {gui = "#808080", cterm = 244},
      exclude_filetypes = {"TelescopePrompt"}
    })

    -- Add keymaps for common Tabnine commands
    vim.keymap.set("n", "<leader>th", "<cmd>TabnineHub<CR>", { desc = "Open Tabnine Hub" })
    vim.keymap.set("n", "<leader>tl", "<cmd>TabnineLogin<CR>", { desc = "Tabnine Login" })
    vim.keymap.set("n", "<leader>ts", "<cmd>TabnineStatus<CR>", { desc = "Tabnine Status" })
    vim.keymap.set("n", "<leader>tt", "<cmd>TabnineToggle<CR>", { desc = "Toggle Tabnine" })

    -- Single debugging command for future troubleshooting
    vim.api.nvim_create_user_command('TabnineDebug', function()
      print("Available Tabnine commands:")
      local commands = vim.api.nvim_get_commands({})
      for name, _ in pairs(commands) do
        if name:match("^Tabnine") then
          print("  " .. name)
        end
      end
    end, {})
  end
}