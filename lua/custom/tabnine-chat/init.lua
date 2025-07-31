-- Tabnine Chat Extension
-- This file provides additional functionality for Tabnine Chat

-- Function to send code to Tabnine Chat with a specific prompt
local function tabnine_chat_with_prompt(prompt)
  -- Get visual selection or current buffer
  local mode = vim.api.nvim_get_mode().mode
  local code = ""

  if mode == 'v' or mode == 'V' or mode == '' then
    -- Get visual selection
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    local lines = vim.api.nvim_buf_get_lines(0, start_pos[2] - 1, end_pos[2], false)

    if #lines == 0 then
      return
    end

    -- Adjust the first and last line for partial selections
    if mode == '' then  -- Visual block mode
      local start_col = start_pos[3]
      local end_col = end_pos[3]
      for i, line in ipairs(lines) do
        lines[i] = line:sub(start_col, end_col)
      end
    else
      if #lines == 1 then
        lines[1] = lines[1]:sub(start_pos[3], end_pos[3])
      else
        lines[1] = lines[1]:sub(start_pos[3])
        lines[#lines] = lines[#lines]:sub(1, end_pos[3])
      end
    end

    code = table.concat(lines, "\n")
  else
    -- Get current buffer
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    code = table.concat(lines, "\n")
  end

  -- Prepare the chat command with the prompt and code
  local chat_command = string.format("TabnineChat %s\n\n```\n%s\n```", prompt, code)

  -- Execute the command
  vim.cmd(chat_command)
end

-- Create user commands for common chat prompts
vim.api.nvim_create_user_command('TabnineChatExplain', function()
  tabnine_chat_with_prompt("Explain this code:")
end, {})

vim.api.nvim_create_user_command('TabnineChatRefactor', function()
  tabnine_chat_with_prompt("Refactor this code to improve:")
end, {})

vim.api.nvim_create_user_command('TabnineChatOptimize', function()
  tabnine_chat_with_prompt("Optimize this code for performance:")
end, {})

vim.api.nvim_create_user_command('TabnineChatDebug', function()
  tabnine_chat_with_prompt("Debug this code and find potential issues:")
end, {})

-- Add keymaps for the chat prompt commands
vim.keymap.set("n", "<leader>tce", "<cmd>TabnineChatExplain<CR>", { desc = "Explain code with Tabnine Chat" })
vim.keymap.set("v", "<leader>tce", "<cmd>TabnineChatExplain<CR>", { desc = "Explain selected code with Tabnine Chat" })

vim.keymap.set("n", "<leader>tcr", "<cmd>TabnineChatRefactor<CR>", { desc = "Refactor code with Tabnine Chat" })
vim.keymap.set("v", "<leader>tcr", "<cmd>TabnineChatRefactor<CR>", { desc = "Refactor selected code with Tabnine Chat" })

vim.keymap.set("n", "<leader>tco", "<cmd>TabnineChatOptimize<CR>", { desc = "Optimize code with Tabnine Chat" })
vim.keymap.set("v", "<leader>tco", "<cmd>TabnineChatOptimize<CR>", { desc = "Optimize selected code with Tabnine Chat" })

vim.keymap.set("n", "<leader>tcd", "<cmd>TabnineChatDebug<CR>", { desc = "Debug code with Tabnine Chat" })
vim.keymap.set("v", "<leader>tcd", "<cmd>TabnineChatDebug<CR>", { desc = "Debug selected code with Tabnine Chat" })

-- Return the module
return {
  tabnine_chat_with_prompt = tabnine_chat_with_prompt
}