# Using Harpoon with Telescope in Neovim

Harpoon is a powerful navigation tool that allows you to quickly jump between your most frequently used files.
This config integrates Harpoon with Telescope, which enhances the file selection experience.

## Keybinding Reference

| Key | Action | Notes |
|-----|--------|-------|
| `<leader>a` | Add current file to Harpoon list | Space + a |
| `<C-e>` | Toggle Harpoon quick menu | Ctrl + e |
| `<A-j>` | Next file in Harpoon list | Alt + j |
| `<A-k>` | Previous file in Harpoon list | Alt + k |
| `<leader>hn` | Next file (leader fallback) | Space + h + n |
| `<leader>hp` | Previous file (leader fallback) | Space + h + p |
| `<leader>fl` | Open Harpoon list in Telescope | Space + f + l |

## Basic Harpoon Commands

1. **Add current file to Harpoon list**:
   - Press `<leader>a` (Space + a)
   - This marks the current file for quick access later

2. **Open Harpoon quick menu**:
   - Press `<C-e>` (Ctrl + e)
   - This shows a simple menu with all your marked files
   - Navigate the menu with `j`/`k`, select with `<CR>`, close with `<Esc>` or `q`

3. **Navigate between marked files (no menu)**:
   - `<A-j>`: Jump to next file in Harpoon list
   - `<A-k>`: Jump to previous file in Harpoon list
   - These wrap around the list automatically

## Why Alt instead of Ctrl for navigation

`<C-j>` and `<C-k>` are occupied by other bindings in this config:

- `<C-j>` → quickfix `cprev` (`keymaps.lua`)
- `<C-k>` → quickfix `cnext` (`keymaps.lua`) and LSP `signature_help` (`lsp.lua`, buffer-local)

The buffer-local LSP binding for `<C-k>` would silently win over any global mapping in code files,
making `<C-k>` → harpoon unreliable. `<A-j>` / `<A-k>` have no conflicts anywhere in the config.

`<C-a>` was also rejected for add() because it is Vim's built-in number-increment primitive.
`<leader>a` is the correct binding for tagging files.

## Using Harpoon with Telescope

This configuration includes a custom integration with Telescope:

1. **Open Harpoon files in Telescope**:
   - Press `<leader>fl` (Space + f + l)
   - This opens your Harpoon list in Telescope's interface
   - You can use all of Telescope's fuzzy filtering, file preview, and sorting on your marked files

## Benefits of the Telescope Integration

- **Better search**: Filter through your marked files using Telescope's fuzzy finder
- **File preview**: See the content of files before jumping to them
- **Visual interface**: Get a more visual representation of your marked files

## Workflow Tips

1. **Mark important files**: When working on a feature, mark the key files you'll be switching between
2. **Use `<A-j>`/`<A-k>` for speed**: Instant file switching with no menu, ideal for two or three marked files
3. **Use `<C-e>` for oriented jumps**: The quick menu shows the full list with index numbers
4. **Use Telescope integration for larger lists**: When you have many marked files, use `<leader>fl` to search by name

## Customization

If you want to modify your setup:

1. All key mappings are defined in `lua/plugins/harpoon.lua`
2. The `toggle_telescope` function at the top of the config block controls the `<leader>fl` integration
3. To add Alt bindings for additional Harpoon list slots (e.g. jump to slot 1, 2, 3), add:
   ```lua
   vim.keymap.set("n", "<A-1>", function() harpoon:list():select(1) end, { desc = "Harpoon file 1" })
   vim.keymap.set("n", "<A-2>", function() harpoon:list():select(2) end, { desc = "Harpoon file 2" })
   ```

This setup gives you the best of both worlds: Harpoon's speed and Telescope's powerful interface.
