# Neovim Configuration Guide

This comprehensive guide covers the setup, usage, and customization of your Neovim configuration. It includes detailed instructions for LSP integration, debugging, and language-specific features with a focus on Python, C/C++, and other supported languages.

## Table of Contents

1. [Introduction](#introduction)
2. [Basic Usage](#basic-usage)
3. [Key Mappings](#key-mappings)
4. [LSP Configuration](#lsp-configuration)
5. [Completion and Snippets](#completion-and-snippets)
6. [Language-Specific Features](#language-specific-features)
   - [Python](#python)
   - [C/C++](#cc)
   - [Lua](#lua)
   - [TypeScript/JavaScript](#typescriptjavascript)
7. [Debugging](#debugging)
8. [Customization](#customization)
9. [Troubleshooting](#troubleshooting)

## Introduction

This Neovim configuration uses [lazy.nvim](https://github.com/folke/lazy.nvim) as the plugin manager and is organized into modular components. The configuration provides IDE-like features including:

- Language Server Protocol (LSP) integration
- Code completion
- Syntax highlighting via Treesitter
- Debugging capabilities
- File navigation and search
- Custom keymaps for efficient editing

## Basic Usage

### Starting Neovim

```bash
nvim                 # Open Neovim
nvim <filename>      # Open a specific file
nvim .               # Open the current directory
```

### Plugin Management

```bash
:Lazy               # Open the Lazy plugin manager interface
:Lazy install       # Install all configured plugins
:Lazy update        # Update plugins
:Lazy clean         # Remove unused plugins
:Lazy sync          # Sync plugins (update and clean)
:Lazy profile       # Show plugin load times
```

### Mason Package Management

```bash
:Mason              # Open the Mason package manager interface
:MasonInstall <pkg> # Install a specific package
:MasonUninstall <pkg> # Uninstall a specific package
:MasonUpdate        # Update all packages
```

## Key Mappings

### General Navigation

| Mapping | Mode | Description |
|---------|------|-------------|
| `<Space>` | All | Leader key |
| `<C-h>` | Normal | Move to left window |
| `<C-l>` | Normal | Move to right window |
| `<C-o>` | Normal | Increase window width by 3 columns |
| `<C-y>` | Normal | Decrease window width by 3 columns |
| `<C-d>` | Normal | Scroll down (cursor stays in middle) |
| `<C-u>` | Normal | Scroll up (cursor stays in middle) |

### File Navigation

| Mapping | Mode | Description |
|---------|------|-------------|
| `<leader>pv` | Normal | Open NetRW file explorer |
| `<leader>ve` | Normal | Open vertical split with NetRW |
| `<leader>he` | Normal | Open horizontal split with NetRW |
| `<leader>ff` | Normal | Find files with Telescope |
| `<leader>fg` | Normal | Live grep with Telescope |
| `<leader>/` | Normal | Fuzzy find in current buffer |
| `<leader>tt` | Normal | Open Telescope |

### Editing

| Mapping | Mode | Description |
|---------|------|-------------|
| `<leader>x` | Normal | Make file executable |
| `J` | Visual | Move selected line(s) down |
| `K` | Visual | Move selected line(s) up |
| `<leader>p` | Visual | Paste without overwriting register |
| `<leader>y` | Normal/Visual | Yank to system clipboard |
| `<leader>Y` | Normal | Yank line to system clipboard |
| `<leader>s` | Normal | Search and replace word under cursor |

### LSP Functionality

| Mapping | Mode | Description |
|---------|------|-------------|
| `gD` | Normal | Go to declaration |
| `gd` | Normal | Go to definition |
| `K` | Normal | Show hover information |
| `gi` | Normal | Go to implementation |
| `<C-k>` | Normal | Show signature help |
| `<leader>rn` | Normal | Rename symbol |
| `<leader>ca` | Normal/Visual | Code action |
| `gr` | Normal | Show references |
| `[d` | Normal | Go to previous diagnostic |
| `]d` | Normal | Go to next diagnostic |
| `<leader>e` | Normal | Show diagnostic in float window |
| `<leader>q` | Normal | Add diagnostic to location list |

### Debugging

| Mapping | Mode | Description |
|---------|------|-------------|
| `<F5>` | Normal | Continue/Start debugging |
| `<F10>` | Normal | Step over |
| `<F11>` | Normal | Step into |
| `<F12>` | Normal | Step out |
| `<Leader>b` | Normal | Toggle breakpoint |
| `<Leader>B` | Normal | Set conditional breakpoint |
| `<Leader>lp` | Normal | Set logpoint |
| `<Leader>dr` | Normal | Open debug REPL |
| `<Leader>dl` | Normal | Run last debug configuration |

## LSP Configuration

The LSP configuration is managed through the `lsp.lua` file and uses Mason for installing and managing language servers.

### Supported Language Servers

- `lua_ls`: Lua language server
- `pyright`: Python language server
- `clangd`: C/C++ language server
- `rust_analyzer`: Rust language server
- `bashls`: Bash language server
- `tsserver`: TypeScript/JavaScript language server

### Adding a New Language Server

To add a new language server, modify the `lsp.lua` file:

```lua
-- File: /home/linux/.config/nvim/lua/plugins/lsp.lua

-- Add to ensure_installed list
require("mason-lspconfig").setup({
    ensure_installed = {
        -- existing servers
        "new_language_server",
    },
    automatic_installation = true,
})

-- Add server-specific configuration
lspconfig.new_language_server.setup({
    -- Server-specific settings
    settings = {
        -- Configuration options
    },
})
```

## Completion and Snippets

Code completion is provided by `nvim-cmp` with integration for LSP, buffer, path, and snippet sources.

### Completion Keybindings

| Mapping | Mode | Description |
|---------|------|-------------|
| `<C-k>` | Insert | Select previous item |
| `<C-j>` | Insert | Select next item |
| `<C-b>` | Insert | Scroll docs backward |
| `<C-f>` | Insert | Scroll docs forward |
| `<C-Space>` | Insert | Show completion menu |
| `<C-e>` | Insert | Close completion menu |
| `<CR>` | Insert | Confirm selection |

### Customizing Completion

To modify completion behavior, edit the `lsp.lua` file:

```lua
-- File: /home/linux/.config/nvim/lua/plugins/lsp.lua

cmp.setup({
    -- Existing configuration
    
    -- Add or modify sources
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
        -- Add new sources here
    }),
    
    -- Customize formatting
    formatting = {
        format = lspkind.cmp_format({
            maxwidth = 50,
            ellipsis_char = "...",
            -- Add custom formatting options
        }),
    },
})
```

## Language-Specific Features

### Python

Python support includes LSP integration via Pyright, debugging with DAP, and test running with Neotest.

#### Python LSP Configuration

```lua
-- File: /home/linux/.config/nvim/lua/plugins/lsp.lua

-- Python LSP configuration (pyright)
lspconfig.pyright.setup({
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
            },
            pythonPath = vim.fn.exepath("python3"),  -- Use Python 3
        },
    },
})
```

#### Python Debugging

To start debugging a Python file:

1. Set breakpoints with `<Leader>b`
2. Press `<F5>` to start debugging
3. Use `<F10>`, `<F11>`, and `<F12>` to step through code
4. View variables in the DAP UI

#### Running Python Tests

```bash
:lua require("neotest").run.run()           # Run nearest test
:lua require("neotest").run.run(vim.fn.expand("%")) # Run current file
:lua require("neotest").run.run({strategy = "dap"}) # Debug nearest test
```

### C/C++

C/C++ support includes LSP integration via clangd, debugging with DAP, and enhanced features through clangd_extensions.

#### C/C++ LSP Configuration

```lua
-- File: /home/linux/.config/nvim/lua/plugins/lsp.lua

-- C/C++ LSP configuration (clangd)
lspconfig.clangd.setup({
    cmd = {
        "clangd",
        "--background-index",
        "--suggest-missing-includes",
        "--clang-tidy",
        "--header-insertion=iwyu",
    },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
    root_dir = function(fname)
        return require("lspconfig.util").root_pattern(
            "compile_commands.json",
            "compile_flags.txt",
            ".git"
        )(fname) or vim.fn.getcwd()
    end,
    init_options = {
        compilationDatabasePath = "build",
    },
})
```

#### C/C++ Debugging

To debug a C/C++ program:

1. Set breakpoints with `<Leader>b`
2. Press `<F5>` to start debugging
3. Enter the path to the executable when prompted
4. Use `<F10>`, `<F11>`, and `<F12>` to step through code

#### Compilation Database

For best results with clangd, create a `compile_commands.json` file in your project:

```bash
# For CMake projects
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON .

# For Make projects, use Bear
bear -- make
```

### Lua

Lua support includes LSP integration via lua_ls and syntax highlighting via Treesitter.

#### Lua LSP Configuration

```lua
-- File: /home/linux/.config/nvim/lua/plugins/lsp.lua

-- Lua LSP configuration
lspconfig.lua_ls.setup({
    settings = {
        Lua = {
            runtime = { version = "Lua 5.1" },
            diagnostics = {
                globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
            },
        },
    },
})
```

### TypeScript/JavaScript

TypeScript and JavaScript support includes LSP integration via tsserver.

#### TypeScript LSP Configuration

```lua
-- File: /home/linux/.config/nvim/lua/plugins/lsp.lua

-- TypeScript LSP configuration
lspconfig.tsserver.setup({
    -- Add TypeScript-specific settings here
})
```

## Debugging

Debugging is provided through the Debug Adapter Protocol (DAP) with language-specific adapters.

### General Debugging Commands

```bash
:lua require('dap').continue()              # Start/continue debugging
:lua require('dap').step_over()             # Step over
:lua require('dap').step_into()             # Step into
:lua require('dap').step_out()              # Step out
:lua require('dap').toggle_breakpoint()     # Toggle breakpoint
:lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) # Set conditional breakpoint
:lua require('dap').