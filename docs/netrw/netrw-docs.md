## NetRW - Vim's Built-in File Explorer

NetRW is Neovim's built-in file explorer that provides powerful file management capabilities without requiring additional plugins.

### Opening NetRW
```bash
nvim .
```

As configured in  `keymaps.lua`, you can split Neovim window in three ways:

```bash
<leader>pv           # Open NetRW in the current window (Ex command)
<leader>ve           # Open NetRW in a vertical split (Vex command)
<leader>he           # Open NetRW in a horizontal split (Sex command)
```

These are the commands that are bound by the key maps above. You can also use the direct commands:

```bash
:Ex                  # Open NetRW in the current window
:Vex                 # Open NetRW in a vertical split
:Sex                 # Open NetRW in a horizontal split
:Lex                 # Open NetRW in the left side (explorer style)
```

### NetRW Navigation

| Key | Action |
|-----|--------|
| `<CR>` or `<Enter>` | Open file/directory |
| `-` | Go up one directory |
| `gb` | Go back to previous directory |
| `gh` | Toggle hidden files |
| `<C-l>` | Refresh the directory listing |
| `<C-w>` followed by movement key | Switch between NetRW and file windows |

### File Operations

| Key | Action |
|-----|--------|
| `%` | Create a new file |
| `d` | Create a new directory |
| `D` | Delete file/directory under cursor |
| `R` | Rename file/directory under cursor |
| `mt` | Mark target directory for file operations |
| `mf` | Mark a file |
| `mc` | Copy marked files to target directory |
| `mm` | Move marked files to target directory |
| `mx` | Execute command on marked files |

### Visual Customization

NetRW's appearance can be customized through various settings in your `init.lua` or a dedicated NetRW configuration file:

```lua
-- File: /home/linux/.config/nvim/lua/config/netrw.lua

-- Hide banner
vim.g.netrw_banner = 0

-- Set the listing style (0-3)
-- 0: thin listing (one file per line)
-- 1: long listing (file size and time)
-- 2: wide listing (multiple files per line)
-- 3: tree style listing
vim.g.netrw_liststyle = 3

-- Set the width when using :Vex or :Lex
vim.g.netrw_winsize = 25

-- Preview files in a vertical split
vim.g.netrw_preview = 1

-- Open files in previous window
vim.g.netrw_browse_split = 4

-- Keep the current directory and browsing directory synced
vim.g.netrw_keepdir = 0
```

### Advanced NetRW Usage

#### Bookmarks

NetRW allows you to bookmark directories for quick access:

```
mb                   # Create a bookmark for the current directory
qb                   # List all bookmarks
{number}gb           # Jump to bookmark number {number}
```

#### File Filtering

You can filter the files displayed in NetRW:

```
:let g:netrw_list_hide = '.*\.swp$,.*\.pyc$'  # Hide swap and pyc files
```

Or toggle hidden files with:

```
gh                   # Toggle hidden files display
```

#### Remote File Editing

NetRW can browse and edit files on remote servers:

```
:e scp://user@host//path/to/file
:e ftp://user@host/path/to/file
:e sftp://user@host/path/to/file
```

#### Integration with Your Workflow

NetRW works well with your configured keymaps for window navigation:

1. Open NetRW with `<leader>pv`
2. Navigate to a file and press `<Enter>` to open it
3. Use `<C-h>` and `<C-l>` to navigate between the file and NetRW
4. Resize the NetRW window with `<C-o>` and `<C-y>`

#### Project-Based Workflow

A common workflow using NetRW:

1. Open a project directory with `nvim .`
2. Use `<leader>pv` to open NetRW
3. Navigate and open files as needed
4. Use `<leader>ff` or `<leader>fg` with Telescope for quick file access
5. Use LSP features like `gd` for code navigation
6. Use `<leader>ve` to open a vertical split with NetRW when needed

### Troubleshooting NetRW

#### Common Issues

1. **NetRW not showing all files**:
   - Check if hidden files are toggled off (use `gh` to toggle)
   - Check if there's a filter active (`g:netrw_list_hide`)

2. **NetRW opening in unexpected ways**:
   - Check your `g:netrw_browse_split` setting

3. **File operations not working**:
   - Ensure you have proper permissions for the directory
   - For remote operations, check your SSH/FTP configuration

#### Disabling NetRW

If you prefer to use another file explorer plugin:

```lua
-- Disable NetRW completely
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
```

## Customization

### Adding New Plugins

To add a new plugin, create a new file in the `lua/plugins/` directory:

```lua
-- File: /home/linux/.config/nvim/lua/plugins/new_plugin.lua

return {
    "author/plugin-name",
    dependencies = {
        -- Add dependencies if needed
    },
    config = function()
        -- Plugin configuration
        require("plugin-name").setup({
            -- Options
        })
        
        -- Keymaps
        vim.keymap.set("n", "<leader>np", function()
            -- Plugin functionality
        end, { desc = "New Plugin Function" })
    end,
}
```

### Modifying Existing Configurations

To modify an existing configuration, edit the corresponding file in the `lua/plugins/` directory.

### Creating Custom Keymaps

To add custom keymaps, edit the `lua/config/keymaps.lua` file:

```lua
-- File: /home/linux/.config/nvim/lua/config/keymaps.lua

-- Add your custom keymaps
vim.keymap.set("n", "<leader>custom", function()
    -- Your custom functionality
end, { desc = "Custom Function" })
```

## Troubleshooting

### Common Issues

1. **Plugin not working**:
   - Check if the plugin is installed (`:Lazy`)
   - Check for errors (`:checkhealth`)
   - Check plugin documentation for requirements

2. **LSP not working**:
   - Ensure the language server is installed (`:Mason`)
   - Check if the language server is configured correctly
   - Look for errors in `:LspInfo`

3. **Keymaps not working**:
   - Check for conflicts with other plugins
   - Verify the keymap is defined correctly
   - Check if the mode is correct (normal, insert, visual)

### Getting Help

- Use `:help` for Neovim documentation
- Check plugin GitHub repositories for issues and documentation
- Join Neovim communities on Discord or Reddit

### Updating

To keep your configuration up to date:

1. Update plugins: `:Lazy update`
2. Update language servers: `:MasonUpdate`
3. Update Neovim itself (depends on your installation method)

## Additional Resources

- [Neovim Documentation](https://neovim.io/doc/)
- [Lazy.nvim Documentation](https://github.com/folke/lazy.nvim)
- [Mason.nvim Documentation](https://github.com/williamboman/mason.nvim)
- [Neovim LSP Documentation](https://neovim.io/doc/user/lsp.html)
- [Treesitter Documentation](https://github.com/nvim-treesitter/nvim-treesitter)
```

### Complete the debugging section and add comprehensive documentation on NetRW:

```markdown
:lua require('dap').repl.open()             # Open debug REPL
:lua require('dap').run_last()              # Run last debug configuration
:lua require('dap').terminate()             # Terminate debug session
:lua require('dap').clear_breakpoints()     # Clear all breakpoints
:lua require('dap.ui.widgets').hover()      # Show value under cursor
```

### DAP UI

The DAP UI provides a visual interface for debugging:

```bash
:lua require('dapui').toggle()              # Toggle DAP UI
:lua require('dapui').eval()                # Evaluate expression
```

### Language-Specific Debugging

Each language has specific debugging configurations. See the respective language sections for details.
This completes the debugging section and adds comprehensive documentation on NetRW, including how to use it and how it integrates with your keymaps in `keymaps.lua`. The NetRW section covers basic navigation, file operations, visual customization, advanced usage, and troubleshooting.