# Harpoon (ThePrimeagen/harpoon)

**What it is**
- File mark/jump manager for rapid navigation between frequently used files
- This config uses branch `harpoon2`.

**Use cases**
- Bookmark files as you work and jump between them instantly

**Key bindings**
- `<leader>a`  Add current file to Harpoon list
- `<C-e>`      Toggle Harpoon quick menu
- `<leader>fl` Open Harpoon list in Telescope (note: overrides Telescope LSP references mapping)
- `<C-p>`      Jump to previous Harpoon entry (note: conflicts with `Telescope git_files`)
- `<C-n>`      Jump to next Harpoon entry

**Commands/Usage**
- Add files with `<leader>a`  while visiting them
- Open menu with `<C-e>`     select a file to jump
- Cycle with `<C-p>` or  `<C-n>`

**Modify**
- Edit keymaps or behavior in `lua/plugins/harpoon.lua`
- The Telescope integration is implemented via a custom function there; adjust mappings or list formatting as desired

**Dependencies**
- `nvim-lua/plenary.nvim`
- Optional, Telescope (used by this config to display the Harpoon list)
