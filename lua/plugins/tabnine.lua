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
      exclude_filetypes = {"TelescopePrompt"},
      -- Enable Tabnine Chat feature
      chat = {
        enable = true,
        shortcut = "<leader>tc", -- Shortcut to open Tabnine Chat
      }
    })

    -- Add keymaps for common Tabnine commands
    vim.keymap.set("n", "<leader>th", "<cmd>TabnineHub<CR>", { desc = "Open Tabnine Hub" })
    vim.keymap.set("n", "<leader>tl", "<cmd>TabnineLogin<CR>", { desc = "Tabnine Login" })
    vim.keymap.set("n", "<leader>ts", "<cmd>TabnineStatus<CR>", { desc = "Tabnine Status" })
    vim.keymap.set("n", "<leader>tt", "<cmd>TabnineToggle<CR>", { desc = "Toggle Tabnine" })
    vim.keymap.set("n", "<leader>tn", "<cmd>TabnineNext<CR>", { desc = "Next Tabnine suggestion" })

    -- When user highligts code tabnine provides option to edit the code with Tabnine
    -- Edit with tabnine
    vim.keymap.set("n", "<leader>tw", "<cmd>TabnineEdit<CR>", { desc = "Edit with Tabnine" })
    -- Fix this code
    vim.keymap.set("n", "<leader>tf", "<cmd>TabnineFix<CR>", { desc = "Fix code with Tabnine" })
    -- Explain this code
    vim.keymap.set("n", "<leader>te", "<cmd>TabnineExplain<CR>", { desc = "Explain code with Tabnine" })
    -- Document this code
    vim.keymap.set("n", "<leader>td", "<cmd>TabnineDocument<CR>", { desc = "Document code with Tabnine" })
    -- Generate test
    vim.keymap.set("n", "<leader>tg", "<cmd>TabnineGenerate<CR>", { desc = "Generate test with Tabnine" })

    -- Add Tabnine Chat specific keymaps
    vim.keymap.set("n", "<leader>tc", "<cmd>TabnineChat<CR>", { desc = "Open Tabnine Chat" })
    vim.keymap.set("v", "<leader>tc", "<cmd>TabnineChat<CR>", { desc = "Open Tabnine Chat with selection" })
    vim.keymap.set("n", "<leader>tch", "<cmd>TabnineChatHistory<CR>", { desc = "View Tabnine Chat history" })
    vim.keymap.set("n", "<leader>tcn", "<cmd>TabnineChatNew<CR>", { desc = "Start new Tabnine Chat" })

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