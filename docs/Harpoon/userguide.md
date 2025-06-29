# Using Harpoon with Telescope in Neovim

Harpoon is a powerful navigation tool that allows you to quickly jump between your most frequently used files. Your configuration already integrates Harpoon with Telescope, which enhances the file selection experience. Here's how to use it:

## Basic Harpoon Commands

1. **Add current file to Harpoon list**:
   - Press `<leader>a` (Space + a)
   - This marks the current file for quick access later

2. **Open Harpoon quick menu**:
   - Press `<C-e>` (Ctrl + e)
   - This shows a simple menu with all your marked files

3. **Navigate between marked files**:
   - `<C-n>`: Go to next file in Harpoon list
   - `<C-p>`: Go to previous file in Harpoon list (note: this conflicts with your Telescope git_files binding)

## Using Harpoon with Telescope

This configuration includes a custom integration with Telescope:

1. **Open Harpoon files in Telescope**:
   - Press `<leader>fl` (Space + f + l)
   - This opens your Harpoon list in Telescope's interface
   - You can use all of Telescope's filtering capabilities on your Harpoon files

## Benefits of the Telescope Integration

- **Better search**: Filter through your marked files using Telescope's fuzzy finder
- **File preview**: See the content of files before jumping to them
- **Visual interface**: Get a more visual representation of your marked files

## Workflow Tips

1. **Mark important files**: When working on a feature, mark the key files you'll be switching between
2. **Use quick menu for speed**: The standard Harpoon menu (`<C-e>`) is faster for simple jumps
3. **Use Telescope integration for searching**: When you have many marked files, use `<leader>fl` to find the right one

## Customization

If you want to modify your setup:

1. The key mappings are defined in your `harpoon.lua` file
2. You might want to change the `<C-p>` mapping as it conflicts with your Telescope git_files binding
3. You can add more Telescope integration features by modifying the `toggle_telescope` function

This setup gives you the best of both worlds: Harpoon's speed and Telescope's powerful interface.
