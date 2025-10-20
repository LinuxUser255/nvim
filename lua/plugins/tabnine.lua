return {
  'codota/tabnine-nvim',
  build = "./dl_binaries.sh",
  lazy = false,  -- Load immediately
  priority = 1000,  -- High priority to ensure it loads before extensions
  config = function()
    -- Load and configure Tabnine
    require('tabnine').setup({
      disable_auto_comment = true,
      accept_keymap = "<Tab>",  -- Tab will work through nvim-cmp
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

    -- Register Tabnine as a source for nvim-cmp
    local has_cmp, cmp = pcall(require, "cmp")
    if has_cmp then
      -- Check if Tabnine source is already registered
      local sources = cmp.get_config().sources
      local has_tabnine_source = false

      for _, source in ipairs(sources or {}) do
        if source.name == "tabnine" then
          has_tabnine_source = true
          break
        end
      end

      -- Add Tabnine as a source if not already present
      if not has_tabnine_source then
        sources = sources or {}
        table.insert(sources, { name = "tabnine", priority = 900 })
        cmp.setup({ sources = sources })
      end
    end
  end,
}