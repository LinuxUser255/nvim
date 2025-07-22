local diagnostics = require("config.diagnostics")

-- Create user commands for diagnostic control
vim.api.nvim_create_user_command('DiagnosticsToggle', function()
  diagnostics.toggle_diagnostics()
end, {})

vim.api.nvim_create_user_command('VirtualTextToggle', function()
  diagnostics.toggle_virtual_text()
end, {})

vim.api.nvim_create_user_command('SuppressErrors', function(opts)
  if opts.args and opts.args ~= "" then
    diagnostics.suppress_by_message(opts.args)
  else
    print("Usage: SuppressErrors <pattern>")
  end
end, {nargs = '?'})

vim.api.nvim_create_user_command('ResetErrorSuppressions', function()
  diagnostics.reset_suppressions()
end, {})
