local M = {}

-- Track the state of diagnostics - set both to false by default
M.diagnostics_active = false
M.virtual_text_active = false

-- Initialize diagnostics default settings
local function initialize_diagnostics()
  -- Configure diagnostics to be disabled using the non-deprecated method
  vim.diagnostic.config({
    virtual_text = false,
    signs = false,
    underline = false,
    update_in_insert = false,
    severity_sort = false,
    float = {
      show_header = false,
      source = false,
      border = "rounded",
      focusable = false,
    },
  })

  print("Diagnostics and virtual text disabled by default")
end

-- Function to toggle all diagnostics
function M.toggle_diagnostics()
  M.diagnostics_active = not M.diagnostics_active
  if M.diagnostics_active then
    -- Enable diagnostics with default settings
    vim.diagnostic.config({
      virtual_text = M.virtual_text_active, -- Respect the virtual text setting
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        show_header = true,
        source = 'always',
        border = "rounded",
        focusable = false,
      },
    })
    print("Diagnostics enabled")
  else
    -- Disable diagnostics
    vim.diagnostic.config({
      virtual_text = false,
      signs = false,
      underline = false,
      update_in_insert = false,
      severity_sort = false,
      float = {
        show_header = false,
        source = false,
        border = "rounded",
        focusable = false,
      },
    })
    print("Diagnostics disabled")
  end
end

-- Function to toggle just the virtual text (inline errors)
function M.toggle_virtual_text()
  M.virtual_text_active = not M.virtual_text_active

  -- Only update if diagnostics are active
  if M.diagnostics_active then
    vim.diagnostic.config({
      virtual_text = M.virtual_text_active,
    })

    if M.virtual_text_active then
      print("Virtual text enabled")
    else
      print("Virtual text disabled")
    end
  else
    print("Note: Diagnostics are currently disabled. Virtual text setting will apply when diagnostics are enabled.")
  end
end

-- Function to suppress specific diagnostic types
function M.suppress_by_message(pattern)
  -- Store the original handler if we haven't already
  if not M.original_handler then
    M.original_handler = vim.diagnostic.handlers.virtual_text.show
    M.suppressed_patterns = {}
  end

  -- Add the pattern to our suppression list
  table.insert(M.suppressed_patterns, pattern)
  print("Suppressing diagnostics matching: " .. pattern)

  -- Override the virtual text handler
  vim.diagnostic.handlers.virtual_text.show = function(namespace, bufnr, diagnostics, opts)
    -- Filter out diagnostics that match any of our patterns
    local filtered_diagnostics = {}
    for _, diagnostic in ipairs(diagnostics) do
      local suppress = false
      for _, pattern in ipairs(M.suppressed_patterns) do
        if string.match(diagnostic.message, pattern) then
          suppress = true
          break
        end
      end
      if not suppress then
        table.insert(filtered_diagnostics, diagnostic)
      end
    end

    -- Call the original handler with filtered diagnostics
    M.original_handler(namespace, bufnr, filtered_diagnostics, opts)
  end
end

-- Function to reset all suppressions
function M.reset_suppressions()
  if M.original_handler then
    vim.diagnostic.handlers.virtual_text.show = M.original_handler
    M.original_handler = nil
    M.suppressed_patterns = {}
    print("All diagnostic suppressions have been reset")
  else
    print("No suppressions were active")
  end
end

-- Call initialize_diagnostics when this module is loaded
initialize_diagnostics()

return M