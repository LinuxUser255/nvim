-- Paste debugging helper
-- Run this with :lua require('config.paste-debug').full_check()

local M = {}

function M.full_check()
    print("\n=== COMPREHENSIVE PASTE DIAGNOSTIC ===")
    print("Time: " .. os.date("%Y-%m-%d %H:%M:%S"))
    
    -- Check clipboard setting
    print("\n--- Clipboard Settings ---")
    print("vim.opt.clipboard = '" .. vim.opt.clipboard:get() .. "'")
    print("Has clipboard support: " .. (vim.fn.has('clipboard') == 1 and "YES" or "NO"))
    
    -- Check for clipboard provider
    local providers = vim.fn.system("which xclip xsel 2>/dev/null")
    print("Clipboard providers found: " .. (providers ~= "" and providers:gsub("\n", " ") or "NONE"))
    
    -- Test actual yank and paste
    print("\n--- Testing Yank & Paste ---")
    
    -- Save current register contents
    local orig_unnamed = vim.fn.getreg('"')
    local orig_plus = vim.fn.getreg('+')
    
    -- Create a test buffer
    local test_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_current_buf(test_buf)
    
    -- Add test content
    vim.api.nvim_buf_set_lines(test_buf, 0, -1, false, {"TEST LINE TO YANK", "Second line", "Third line"})
    
    -- Yank first line
    vim.cmd('normal! ggY')
    
    -- Check registers after yank
    local after_yank_unnamed = vim.fn.getreg('"')
    local after_yank_plus = vim.fn.getreg('+')
    
    print("After yank (Y):")
    print('  Unnamed reg ("):  "' .. (after_yank_unnamed:gsub("\n", "\\n")) .. '"')
    print('  Plus reg (+):     "' .. (after_yank_plus:gsub("\n", "\\n")) .. '"')
    
    -- Try to paste
    vim.cmd('normal! G')  -- Go to last line
    vim.cmd('normal! o')  -- New line
    vim.cmd('normal! p')  -- Paste
    
    local lines_after_paste = vim.api.nvim_buf_get_lines(test_buf, 0, -1, false)
    print("\nBuffer after paste attempt:")
    for i, line in ipairs(lines_after_paste) do
        print("  Line " .. i .. ": " .. line)
    end
    
    -- Clean up test buffer
    vim.api.nvim_buf_delete(test_buf, {force = true})
    
    -- Restore original registers
    vim.fn.setreg('"', orig_unnamed)
    vim.fn.setreg('+', orig_plus)
    
    M.check_paste_mappings()
end

function M.check_paste_mappings()
    print("\n--- Paste Mappings ---")
    
    -- Check normal mode 'p' mapping
    local p_mapping = vim.fn.maparg('p', 'n', false, true)
    if p_mapping and p_mapping.lhs then
        print("'p' in normal mode:")
        print("  Mapped to: " .. (p_mapping.rhs or "(function)"))
        print("  From: " .. (p_mapping.script or "unknown"))
    else
        print("'p' in normal mode: default (should paste)")
    end
    
    -- Check visual mode 'p' mapping  
    local vp_mapping = vim.fn.maparg('p', 'v')
    if vp_mapping ~= '' then
        print("'p' in visual mode is remapped to: " .. vp_mapping)
    else
        print("'p' in visual mode: default")
    end
    
    -- Check P mappings
    local P_mapping = vim.fn.maparg('P', 'n')
    if P_mapping ~= '' then
        print("'P' in normal mode is remapped to: " .. P_mapping)
    else
        print("'P' in normal mode: default (should paste before)")
    end
    
    -- Check unnamed register
    local unnamed = vim.fn.getreg('"')
    if unnamed ~= '' then
        print('\nUnnamed register (") contains: ' .. string.sub(unnamed, 1, 50))
    else
        print('\nUnnamed register (") is empty')
    end
    
    -- Check system clipboard
    local has_clipboard = vim.fn.has('clipboard') == 1
    print("\nClipboard support: " .. (has_clipboard and "Yes" or "No"))
    
    -- Check if any autocmds might interfere
    print("\n=== Checking for interfering autocmds ===")
    local autocmds = vim.api.nvim_get_autocmds({event = {"TextYankPost", "BufEnter", "InsertLeave"}})
    for _, autocmd in ipairs(autocmds) do
        if autocmd.callback or autocmd.command then
            local desc = autocmd.desc or autocmd.command or "callback function"
            print(string.format("Event: %s, Group: %s, Desc: %s", 
                autocmd.event, 
                autocmd.group_name or "unnamed", 
                desc))
        end
    end
end

-- Test paste functionality
function M.test_paste()
    print("\n=== Testing Paste Operations ===")
    
    -- Save current buffer content
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    
    -- Create test text
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {"Test line 1", "Test line 2", "Test line 3"})
    
    -- Yank first line
    vim.cmd('normal! ggY')
    local yanked = vim.fn.getreg('"')
    print("Yanked text: '" .. yanked .. "'")
    
    -- Try to paste
    vim.cmd('normal! G')  -- Go to last line
    vim.cmd('normal! p')   -- Paste after
    
    -- Check result
    local new_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    print("Buffer after paste:")
    for i, line in ipairs(new_lines) do
        print("  " .. i .. ": " .. line)
    end
    
    -- Restore original content
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
end

-- Run diagnostics
M.check_paste_mappings()

return M