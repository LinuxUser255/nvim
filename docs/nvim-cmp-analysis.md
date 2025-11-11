# nvim-cmp.lua Configuration Analysis

## Overview

This document provides a detailed analysis and breakdown of the `lua/plugins/nvim-cmp.lua` configuration file, which sets up **nvim-cmp** - a powerful completion engine for Neovim.

## Plugin Structure

The file follows the lazy.nvim plugin specification format:

```lua
return {
    "hrsh7th/nvim-cmp",
    config = function()
        -- configuration logic
    end,
    dependencies = {
        -- required plugins
    },
}
```

## Core Components

### Required Modules

The configuration loads three essential modules:

```lua
local cmp = require("cmp")      -- The completion engine itself
local luasnip = require("luasnip")  -- Snippet engine for code snippets
local lspkind = require("lspkind")  -- VS Code-like icons for completion items
```

### Snippet Loading

VS Code-style snippets are loaded lazily for better performance:

```lua
require("luasnip/loaders/from_vscode").lazy_load()
```

### Vim Completion Options

```lua
vim.opt.completeopt = "menu,menuone,noselect"
```

- `menu`: Shows the completion menu
- `menuone`: Shows menu even with a single match
- `noselect`: Doesn't auto-select the first item

## Main Configuration

### Snippet Expansion

Defines how snippets are expanded when selected:

```lua
snippet = {
    expand = function(args)
        luasnip.lsp_expand(args.body)
    end,
},
```

### Key Mappings

The configuration uses intuitive key mappings for navigation and control:

| Key Binding | Action | Description |
|-------------|--------|-------------|
| `<C-k>` | `select_prev_item()` | Move to previous completion item |
| `<C-j>` | `select_next_item()` | Move to next completion item |
| `<C-b>` | `scroll_docs(-4)` | Scroll documentation up by 4 lines |
| `<C-f>` | `scroll_docs(4)` | Scroll documentation down by 4 lines |
| `<C-Space>` | `complete()` | Manually trigger completion suggestions |
| `<C-e>` | `abort()` | Close/abort the completion window |
| `<CR>` | `confirm({ select = false })` | Confirm selection without auto-selecting |

### Completion Sources

Sources are configured with priority order (first has highest priority):

```lua
sources = cmp.config.sources({
    { name = "nvim_lsp" },  -- Language server protocol completions
    { name = "luasnip" },   -- Snippet suggestions
    { name = "buffer" },    -- Text within current buffer
    { name = "path" },      -- File system paths
}),
```

#### Source Descriptions

1. **nvim_lsp**: Intelligent completions from language servers
2. **luasnip**: Code snippet templates
3. **buffer**: Words from the current file
4. **path**: File and directory paths

### Formatting Configuration

The completion menu is enhanced with icons and formatting:

```lua
formatting = {
    format = lspkind.cmp_format({
        maxwidth = 50,           -- Maximum item width
        ellipsis_char = "...",   -- Truncation indicator
    }),
},
```

## Dependencies

### 1. lspkind.nvim
- **Plugin**: `onsails/lspkind.nvim`
- **Purpose**: Provides VS Code-style icons for completion items
- **Features**: Visual distinction between different completion types (functions, variables, snippets, etc.)

### 2. LuaSnip
- **Plugin**: `L3MON4D3/LuaSnip`
- **Version**: `2.*` (latest v2 release)
- **Build**: `make install_jsregexp` (for enhanced regex support)
- **Purpose**: Powerful snippet engine with advanced features

## Key Features

### Multi-Source Intelligence
Combines multiple completion sources for comprehensive suggestions:
- LSP for language-aware completions
- Snippets for boilerplate code
- Buffer words for context-aware suggestions
- File paths for easy file references

### User-Friendly Navigation
- Vim-style `j/k` navigation (via Ctrl)
- Documentation scrolling without leaving insert mode
- Manual completion triggering when needed

### Visual Enhancements
- Icons for different completion types
- Width limits for readability
- Ellipsis for truncated items

### Non-Intrusive Behavior
- No automatic selection (`select = false`)
- Explicit confirmation required
- Easy abort/cancel option

### Performance Optimizations
- Lazy loading of snippets
- Efficient source prioritization
- Minimal overhead configuration

## Integration with Other Components

Based on the Neovim configuration architecture, nvim-cmp integrates with:

### Tabnine AI Integration
- Enhanced by `cmp-tabnine.lua` for AI-powered completions
- Provides intelligent code suggestions based on context

### Language Server Protocol
- Works with LSP servers configured in `lsp.lua`
- Supports multiple languages:
  - Lua (`lua_ls`)
  - Rust (`rust_analyzer`)
  - Python (`pyright`)
  - C/C++ (`clangd`)
  - Bash (`bashls`)
  - Go (`gopls`)

### Language-Specific Enhancements
- Custom completion behaviors per language
- Integration with language-specific plugins

## Usage Tips

### Triggering Completions
1. **Automatic**: Start typing and completions appear
2. **Manual**: Press `<C-Space>` to force completion menu

### Navigating Completions
1. Use `<C-j>` and `<C-k>` to move through items
2. Use `<C-f>` and `<C-b>` to read documentation
3. Press `<CR>` to accept, `<C-e>` to cancel

### Snippet Expansion
1. Select a snippet from completions
2. Press `<CR>` to expand
3. Use Tab/Shift-Tab to navigate placeholders (if configured)

## Customization Options

### Adding More Sources
To add additional completion sources, modify the sources array:

```lua
sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
    { name = "your_new_source" },  -- Add new source here
}),
```

### Modifying Key Mappings
Key mappings can be customized in the mapping section:

```lua
mapping = cmp.mapping.preset.insert({
    -- Add or modify mappings here
    ["<Tab>"] = cmp.mapping.select_next_item(),
}),
```

### Adjusting Formatting
Modify the formatting section for different visual preferences:

```lua
formatting = {
    format = lspkind.cmp_format({
        maxwidth = 80,  -- Increase width
        ellipsis_char = "→",  -- Different truncation character
        mode = "symbol_text",  -- Show both icon and text
    }),
},
```

## Troubleshooting

### Common Issues

1. **Completions not appearing**
   - Check if LSP servers are running (`:LspInfo`)
   - Verify sources are properly configured
   - Ensure dependencies are installed

2. **Snippets not expanding**
   - Verify LuaSnip is installed
   - Check if snippet files are loaded
   - Ensure jsregexp is built (`make install_jsregexp`)

3. **Icons not showing**
   - Install a Nerd Font
   - Verify lspkind is loaded
   - Check terminal font settings

### Debug Commands
```vim
:CmpStatus          " Check cmp status
:LspInfo           " Verify LSP servers
:checkhealth nvim-cmp  " Run health check
```

## Performance Considerations

- **Lazy Loading**: Snippets load on-demand
- **Source Priority**: Most relevant sources first
- **Buffer Limits**: Consider limiting buffer source for large files
- **Update Frequency**: Adjust debounce settings if needed

## Related Documentation

- [Config Structure](Config-Structure.md) - Overall configuration architecture
- [LSP Configuration](lsp.lua) - Language server setup
- [Tabnine Integration](Tabnine-Integration.md) - AI completion setup
- [Keymaps](../lua/config/keymaps.lua) - Global keybindings

## References

- [nvim-cmp GitHub](https://github.com/hrsh7th/nvim-cmp)
- [LuaSnip Documentation](https://github.com/L3MON4D3/LuaSnip)
- [lspkind.nvim](https://github.com/onsails/lspkind.nvim)