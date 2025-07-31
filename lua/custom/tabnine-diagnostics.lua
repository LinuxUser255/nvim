local M = {}

-- Function to check if Tabnine is properly installed and configured
function M.diagnose()
  print("=== Tabnine Diagnostics ===")

  -- Check if the Tabnine plugin is loaded
  local tabnine_loaded, tabnine = pcall(require, "tabnine")
  if not tabnine_loaded then
    print("❌ Tabnine plugin is not loaded")
    return false
  else
    print("✓ Tabnine plugin is loaded")
  end

  -- Check if the binary exists
  local binary_path = vim.fn.stdpath("data") .. "/lazy/tabnine-nvim/binaries"
  if vim.fn.isdirectory(binary_path) == 0 then
    print("❌ Tabnine binaries directory not found at: " .. binary_path)
    print("   Try running the build script manually:")
    print("   cd " .. vim.fn.stdpath("data") .. "/lazy/tabnine-nvim && ./dl_binaries.sh")
    return false
  else
    print("✓ Tabnine binaries directory exists")

    -- Check if there are any files in the binaries directory
    local handle = io.popen("ls -la " .. binary_path)
    if handle then
      local result = handle:read("*a")
      handle:close()
      print("Binary directory contents:")
      print(result)
    end
  end

  -- Check if the chat binary exists
  local plugin_path = vim.fn.stdpath("data") .. "/lazy/tabnine-nvim"
  local chat_dir = plugin_path .. "/chat"

  if vim.fn.isdirectory(chat_dir) == 1 then
    print("✓ Tabnine Chat directory exists")

    -- Check if the chat binary is built
    local chat_binary = chat_dir .. "/target/release/tabnine_chat"
    if vim.fn.filereadable(chat_binary) == 1 then
      print("✓ Tabnine Chat binary exists")
    else
      print("❌ Tabnine Chat binary not found at: " .. chat_binary)
      print("   You need to build it with: cd " .. chat_dir .. " && cargo build --release")
    end
  else
    print("❌ Tabnine Chat directory not found at: " .. chat_dir)
  end

  -- Check if Tabnine commands are available
  local commands = vim.api.nvim_get_commands({})
  local tabnine_commands = {}
  for name, _ in pairs(commands) do
    if name:match("^Tabnine") then
      table.insert(tabnine_commands, name)
    end
  end

  if #tabnine_commands == 0 then
    print("❌ No Tabnine commands found")
    return false
  else
    print("✓ Tabnine commands available:")
    for _, cmd in ipairs(tabnine_commands) do
      print("  - " .. cmd)
    end
  end

  -- Check if TabnineChat command exists specifically
  local has_chat_command = false
  for _, cmd in ipairs(tabnine_commands) do
    if cmd == "TabnineChat" then
      has_chat_command = true
      break
    end
  end

  if not has_chat_command then
    print("❌ TabnineChat command not found")
    print("   This might indicate that Tabnine Pro features are not available")
    print("   or that you need to log in with :TabnineLogin")
    return false
  else
    print("✓ TabnineChat command is available")
  end

  print("=== Diagnostics Complete ===")
  print("If Tabnine is still not working, try the following:")
  print("1. Run :TabnineLogin to ensure you're logged in")
  print("2. Run :TabnineInstallBinaries to reinstall the main binaries")
  print("3. Run :TabnineBuildChat to build the chat binary")
  print("4. Check if you have a valid Tabnine subscription for Chat features")

  return true
end

-- Function to manually run the dl_binaries.sh script
function M.install_binaries()
  local plugin_path = vim.fn.stdpath("data") .. "/lazy/tabnine-nvim"
  local script_path = plugin_path .. "/dl_binaries.sh"

  if vim.fn.filereadable(script_path) == 0 then
    print("❌ Binary download script not found at: " .. script_path)
    return false
  end

  print("Running Tabnine binary download script...")
  local cmd = "cd " .. plugin_path .. " && chmod +x ./dl_binaries.sh && ./dl_binaries.sh"

  local handle = io.popen(cmd)
  if handle then
    local result = handle:read("*a")
    handle:close()
    print(result)
    print("✓ Tabnine binaries download completed")
    print("Please restart Neovim for changes to take effect")
    return true
  else
    print("❌ Failed to run binary download script")
    return false
  end
end

-- Function to build the Tabnine Chat binary
function M.build_chat_binary()
  -- Check if Rust/Cargo is installed
  local cargo_check = io.popen("which cargo")
  local cargo_path = cargo_check:read("*l")
  cargo_check:close()

  if not cargo_path or cargo_path == "" then
    print("❌ Cargo not found. Please install Rust and Cargo first:")
    print("   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh")
    return false
  end

  local plugin_path = vim.fn.stdpath("data") .. "/lazy/tabnine-nvim"
  local chat_dir = plugin_path .. "/chat"

  if vim.fn.isdirectory(chat_dir) == 0 then
    print("❌ Tabnine Chat directory not found at: " .. chat_dir)
    return false
  end

  print("Building Tabnine Chat binary (this may take a few minutes)...")
  local cmd = "cd " .. chat_dir .. " && cargo build --release"

  local handle = io.popen(cmd)
  if handle then
    local result = handle:read("*a")
    handle:close()

    -- Check if the binary was successfully built
    local chat_binary = chat_dir .. "/target/release/tabnine_chat"
    if vim.fn.filereadable(chat_binary) == 1 then
      print("✓ Tabnine Chat binary built successfully")
      print("Please restart Neovim for changes to take effect")
      return true
    else
      print("❌ Failed to build Tabnine Chat binary. Build output:")
      print(result)
      return false
    end
  else
    print("❌ Failed to run build command")
    return false
  end
end

return M