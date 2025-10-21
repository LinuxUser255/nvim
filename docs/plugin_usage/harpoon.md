# Harpoon

**Plugin:** `ThePrimeagen/harpoon` (branch: `harpoon2`)  
**Purpose:** Lightning-fast file navigation and bookmarking system

## Overview

Harpoon is a file mark/jump manager that enables rapid navigation between frequently used files. Think of it as project-specific bookmarks that persist across sessions.

## Key Features

- **Quick file marking** - Instantly bookmark any file you're working on
- **Rapid navigation** - Jump to bookmarked files without file explorers or fuzzy finders
- **Persistent marks** - Bookmarks persist per project across Neovim sessions
- **Telescope integration** - View and manage marks through Telescope UI

## Key Bindings

### Core Operations

| Keybinding | Action | Description |
|------------|--------|-------------|
| `<leader>a` | Add file | Add current file to Harpoon list |
| `<C-e>` | Toggle menu | Open/close Harpoon quick menu |
| `<leader>fl` | Telescope view | Browse Harpoon list in Telescope |

### Navigation

| Keybinding | Action | Description |
|------------|--------|-------------|
| `<C-n>` | Next file | Jump to next file in Harpoon list |
| `<C-p>` | Previous file | Jump to previous file in list |

> **⚠️ Conflicts:**  
> - `<leader>fl` overrides Telescope LSP references  
> - `<C-p>` conflicts with `Telescope git_files`

## Usage Examples

### Basic Workflow

1. **Mark files as you work:**
   ```
   Open a file → Press <leader>a to add it to Harpoon
   ```

2. **Navigate between marked files:**
   ```
   <C-e>  → View all marked files and select one
   <C-n>  → Cycle forward through marks
   <C-p>  → Cycle backward through marks
   ```

3. **Manage marks via Telescope:**
   ```
   <leader>fl → Opens interactive list with search/filter
   ```

### Typical Use Case

When working on a feature that touches multiple files:

1. Open `controller.js` → `<leader>a` (mark it)
2. Open `model.js` → `<leader>a` (mark it) 
3. Open `view.js` → `<leader>a` (mark it)
4. Now jump between these three files instantly with `<C-n>`/`<C-p>`
5. Or use `<C-e>` to see all marks and pick one

## Configuration

**Location:** `lua/plugins/harpoon.lua`

### Customization Options

- **Modify keybindings** - Change the default mappings in the config file
- **Adjust list display** - Customize how files appear in the menu
- **Telescope formatting** - Modify the custom Telescope integration function

## Dependencies

- **Required:** `nvim-lua/plenary.nvim`
- **Optional:** `nvim-telescope/telescope.nvim` (for Telescope integration)

## Tips

- Keep your Harpoon list small (3-5 files) for maximum efficiency
- Use it for "working set" files you're actively editing
- Clear marks regularly when switching tasks
- Consider it as a complement to, not replacement for, fuzzy finders
