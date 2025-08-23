-- SET DEFAULT COLORSCHEME ON LINE 125:  vim.cmd.colorscheme "catppuccin"
return {
    {
        -- Catppuccin colorscheme
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "mocha", -- latte, frappe, macchiato, mocha
                background = { -- :h background
                    light = "latte",
                    dark = "mocha",
                },
                transparent_background = false, -- disables setting the background color.
                show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
                term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
                dim_inactive = {
                    enabled = false, -- dims the background color of inactive window
                    shade = "dark",
                    percentage = 0.15, -- percentage of the shade to apply to the inactive window
                },
                no_italic = false, -- Force no italic
                no_bold = false, -- Force no bold
                no_underline = false, -- Force no underline
                styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
                    comments = { "italic" }, -- Change the style of comments
                    conditionals = { "italic" },
                    loops = {},
                    functions = {},
                    keywords = {},
                    strings = {},
                    variables = {},
                    numbers = {},
                    booleans = {},
                    properties = {},
                    types = {},
                    operators = {},
                    -- miscs = {}, -- Uncomment to turn off hard-coded styles
                },
                color_overrides = {},
                custom_highlights = {},
                default_integrations = true,
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    nvimtree = true,
                    treesitter = true,
                    notify = false,
                    mini = {
                        enabled = true,
                        indentscope_color = "",
                    },
                    -- For more plugins integrations https://github.com/catppuccin/nvim#integrations
                },
            })
        end
    },
    {
        -- Tokyonight theme
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("tokyonight").setup({
                style = "storm", -- The theme comes in three styles: storm, moon, night, day
                transparent = false, -- Enable this to disable setting the background color
                terminal_colors = true, -- Configure the colors used when opening a `:terminal`
                styles = {
                    comments = { italic = true },
                    keywords = { italic = true },
                    functions = {},
                    variables = {},
                    sidebars = "dark", -- style for sidebars
                    floats = "dark", -- style for floating windows
                },
                sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows
                day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style
                hide_inactive_statusline = false, -- Enabling this option will hide inactive statuslines
                dim_inactive = false, -- dims inactive windows
                lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold
            })
        end
    },
    {
        -- Rosepine
        "rose-pine/neovim",
        name = "rose-pine",
        priority = 1000,
        config = function()
            require("rose-pine").setup({
                variant = "auto", -- auto, main, moon, or dawn
                dark_variant = "main", -- main or moon
                dim_inactive_windows = false,
                extend_background_behind_borders = true,
                styles = {
                    bold = true,
                    italic = true,
                    transparency = false,
                },
                highlight_groups = {
                    -- Custom highlight group adjustments go here
                }
            })
        end
    },
    {
        "nvim-lua/plenary.nvim", -- Required for theme switching command
        lazy = false,
    },
    {
        "nvim-telescope/telescope.nvim", -- Required for theme selection UI
        lazy = false,
    },
    {
        "nvim-lua/popup.nvim", -- Required for theme selection UI
        lazy = false,
    },
    {
        "rcarriga/nvim-notify", -- Add this plugin for theme switching notifications
        name = "nvim-notify",   -- Add a name for this plugin
        priority = 1000,
        config = function()
            -- SET DEFAULT COLORSCHEME
            vim.cmd.colorscheme "rose-pine"

            -- Command to switch between themes
                vim.api.nvim_create_user_command('Color', function()
                local themes = {
                    { name = "Catppuccin - Latte (Light)", value = "catppuccin-latte" },
                    { name = "Catppuccin - Frappe", value = "catppuccin-frappe" },
                    { name = "Catppuccin - Macchiato", value = "catppuccin-macchiato" },
                    { name = "Catppuccin - Mocha (Dark)", value = "catppuccin" },
                    { name = "Tokyo Night - Storm", value = "tokyonight-storm" },
                    { name = "Tokyo Night - Night", value = "tokyonight-night" },
                    { name = "Tokyo Night - Moon", value = "tokyonight-moon" },
                    { name = "Tokyo Night - Day (Light)", value = "tokyonight-day" },
                    { name = "Rose Pine - Main (Dark)", value = "rose-pine" },
                    { name = "Rose Pine - Moon (Dark)", value = "rose-pine-moon" },
                    { name = "Rose Pine - Dawn (Light)", value = "rose-pine-dawn" },
                }

                local actions = require('telescope.actions')
                local action_state = require('telescope.actions.state')
                local pickers = require('telescope.pickers')
                local finders = require('telescope.finders')
                local sorters = require('telescope.sorters')
                local dropdown = require('telescope.themes').get_dropdown()


                pickers.new(dropdown, {
                    prompt_title = 'Select Theme',
                    finder = finders.new_table {
                        results = themes,
                        entry_maker = function(entry)
                            return {
                                value = entry,
                                display = entry.name,
                                ordinal = entry.name,
                            }
                        end,
                    },
                    sorter = sorters.get_generic_fuzzy_sorter(),
                    attach_mappings = function(prompt_bufnr, _)
                        actions.select_default:replace(function()
                            local selection = action_state.get_selected_entry()
                            actions.close(prompt_bufnr)

                            -- Apply the selected theme
                            vim.cmd.colorscheme(selection.value.value)

                            -- Notify the user
                            vim.notify('Theme switched to ' .. selection.value.name, vim.log.levels.INFO)
                        end)
                        return true
                    end,
                }):find()
            end, {})

            -- Add a keymap for quick access
            vim.keymap.set('n', '<leader>ct', '<cmd>Color<CR>', { desc = 'Change Theme' })
        end
    }
}
