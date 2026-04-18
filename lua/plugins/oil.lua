-- Oil.nvim: Modern file explorer replacing netrw
-- Fixes Neovim 0.12 netrw regression issues
return {
  "stevearc/oil.nvim",
  lazy = false,  -- Load immediately to handle 'nvim .' startup
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    -- Oil will take over directory buffers (e.g. `nvim .` or `:e src/`)
    default_file_explorer = true,
    -- Show hidden files by default
    view_options = {
      show_hidden = true,
    },
    -- Skip confirmation for simple operations
    skip_confirm_for_simple_edits = true,
    -- Keymaps in oil buffer (defaults are sensible, listing for reference)
    keymaps = {
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["<C-s>"] = "actions.select_vsplit",
      ["<C-h>"] = "actions.select_split",
      ["<C-t>"] = "actions.select_tab",
      ["<C-p>"] = "actions.preview",
      ["<C-c>"] = "actions.close",
      ["<C-l>"] = "actions.refresh",
      ["-"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["`"] = "actions.cd",
      ["~"] = "actions.tcd",
      ["gs"] = "actions.change_sort",
      ["gx"] = "actions.open_external",
      ["g."] = "actions.toggle_hidden",
    },
    -- Use oil's floating window for previews
    float = {
      padding = 2,
      max_width = 0,  -- 0 = no max
      max_height = 0,
      border = "rounded",
      win_options = {
        winblend = 0,
      },
    },
  },
}
