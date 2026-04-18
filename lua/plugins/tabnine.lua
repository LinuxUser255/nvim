-- DISABLED: TabNine binary download fails with 403 error
-- Re-enable when TabNine fixes their CDN/download infrastructure
return {
  'codota/tabnine-nvim',
  enabled = true,  -- Maybe Disabled due to 403 Node.js download error
  build = "./dl_binaries.sh",
  lazy = true,
  -- priority = 1000,
  config = function()
    -- macOS branch: Configure Tabnine for direct integration
    require('tabnine').setup({
      disable_auto_comment = true,
      accept_keymap = "<Tab>",  -- Tab will work through nvim-cmp
      dismiss_keymap = "<C-]>",
      debounce_ms = 800,
      suggestion_color = {gui = "#808080", cterm = 244},
      exclude_filetypes = {"TelescopePrompt", "vim"},
      -- Enable Tabnine Chat feature
      chat = {
        enable = true,
        shortcut = "<leader>tc", -- Shortcut to open Tabnine Chat
      }
    })

    -- Register cmp_tabnine source for nvim-cmp
    local has_cmp_tabnine, cmp_tabnine = pcall(require, 'cmp_tabnine.config')
    if has_cmp_tabnine then
      cmp_tabnine:setup({
        max_lines = 1000,
        max_num_results = 3,
        sort = true,
        run_on_every_keystroke = true,
        snippet_placeholder = '..',
        ignored_file_types = {},
        show_prediction_strength = false
      })
    end

    -- Keymaps for common Tabnine commands
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

    -- Tabnine Chat specific keymaps
    vim.keymap.set("n", "<leader>tc", "<cmd>TabnineChat<CR>", { desc = "Open Tabnine Chat" })
    vim.keymap.set("v", "<leader>tc", "<cmd>TabnineChat<CR>", { desc = "Open Tabnine Chat with selection" })
    vim.keymap.set("n", "<leader>tch", "<cmd>TabnineChatHistory<CR>", { desc = "View Tabnine Chat history" })
    vim.keymap.set("n", "<leader>tcn", "<cmd>TabnineChatNew<CR>", { desc = "Start new Tabnine Chat" })

    -- Simple debug command for troubleshooting (no verbose diagnostics)
    vim.api.nvim_create_user_command('TabnineDebug', function()
      vim.notify("Tabnine is " .. (vim.g.tabnine_enabled and "enabled" or "disabled"), vim.log.levels.INFO)
      -- List available commands quietly
      local commands = vim.api.nvim_get_commands({})
      local tabnine_cmds = {}
      for name, _ in pairs(commands) do
        if name:match("^Tabnine") then
          table.insert(tabnine_cmds, name)
        end
      end
      if #tabnine_cmds > 0 then
        vim.notify("Available Tabnine commands: " .. table.concat(tabnine_cmds, ", "), vim.log.levels.INFO)
      end
    end, {})

    -- macOS: Tabnine source registration handled in nvim-cmp config directly
  end,
}
