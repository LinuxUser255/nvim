# How This Neovim Configuration Works

*A note on all of this:*
There are countless Neovim configurations out there.
Throughout my Neovim config journey, one of the biggest frustrations has been the lack of strict or standardized architecture—and no universal templates to follow.

Yes, the high-level overview is consistent: Neovim looks for `init.lua` in `$XDG_CONFIG_HOME/nvim`,
and your Neovim environment spawns from there.
However, from that point on, things can go in many different directions.

Understanding the *code flow* of other people's Neovim configurations often requires significant time and mental overhead—depending on their complexity.

Part of my goal in creating this configuration was not only to build something that works best for me,
but also to provide comprehensive and detailed documentation.

This is something others can use and follow when creating their own config—similar in spirit to [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).
Take what you like from mine; leave what you don’t.

It's my hope that by leaving detailed blueprints, it will be easy for anyone to *leggo* their own Neovim configuration environment.


## Overview of Configuration Structure

This Neovim configuration uses a modular approach where functionality is split
across multiple Lua files that work together.
Here is how everything is connected:

## Configuration Flow

1. **Entry Point**: `/home/linux/.config/nvim/init.lua`
   - This is the first file Neovim loads when starting
   - It contains just one line: `require('config')`
   - This imports the `config` module, which is the main configuration hub

2. **Main Configuration Hub**: `/home/linux/.config/nvim/lua/config/init.lua`
   - Sets up leader keys (`Space` as leader)
   - Loads the lazy.nvim plugin manager
   - Imports other core configuration files:
     ```lua
     require('config.options')  -- Editor options
     require("config.globals")  -- Global variables
     require('config.keymaps')  -- Key mappings
     ```
   - Sets up the plugin system: `require('lazy').setup('plugins')`

3. **Plugin System**:
   - The `plugins` directory contains individual Lua files for each plugin or group of related plugins
   - Each file returns a table that defines plugin configurations
   - `lazy.nvim` automatically loads all files in the `plugins` directory

4. **Custom Extensions**:
   - Custom functionality like `tabnine-chat` is defined in the `lua/custom` directory
   - These are loaded as plugins through files like `plugins/tabnine-chat.lua`

## How Files Work Together

```
┌─────────────────┐
│ init.lua        │
│ require('config')│
└────────┬────────┘
         │
         ▼
┌─────────────────────────┐
│ lua/config/init.lua     │
│ - Sets up lazy.nvim     │
│ - Loads core configs    │
│ - Sets up plugin system │
└───┬───────┬───────┬─────┘
    │       │       │
    ▼       ▼       ▼
┌─────────┐ ┌─────────┐ ┌─────────┐
│ options │ │ globals │ │ keymaps │
└─────────┘ └─────────┘ └─────────┘
    │
    ▼
┌─────────────────────┐
│ lazy.nvim           │
│ Plugin Manager      │
└─────────┬───────────┘
          │
          ▼
┌─────────────────────────────────────────────────┐
│ lua/plugins/*.lua                               │
│ (lsp.lua, treesitter.lua, cpp.lua, etc.)        │
└───────────────────────┬─────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────┐
│ Custom Extensions (lua/custom/*)                │
│ e.g., tabnine-chat integration                  │
└─────────────────────────────────────────────────┘
```

## Key Components

1. **Plugin Management**:
   - `lazy.nvim` handles plugin loading and dependencies
   - Plugins are defined in individual files in the `plugins` directory
   - Each plugin file returns a table with configuration options

2. **LSP Configuration** (`plugins/lsp.lua`):
   - Sets up language servers for different programming languages
   - Configures completion with `nvim-cmp`
   - Defines keybindings for LSP functionality

3. **Syntax Highlighting** (`plugins/treesitter.lua`):
   - Configures Tree-sitter for advanced syntax highlighting
   - Defines which languages to support

4. **Language-Specific Setups**:
   - Files like `plugins/cpp.lua` provide specialized tools for specific languages
   - Includes debugging support, language-specific extensions, etc.

5. **Custom Extensions** (`lua/custom/tabnine-chat`):
   - Provides additional functionality like AI-assisted coding with Tabnine

## Loading Sequence

1. Neovim starts and loads `init.lua`
2. `init.lua` requires the `config` module
3. `config/init.lua` sets up basic configuration and loads `lazy.nvim`
4. `lazy.nvim` loads all plugin definitions from the `plugins` directory
5. Each plugin is initialized according to its configuration
6. Custom extensions are loaded as part of the plugin system

<br>

