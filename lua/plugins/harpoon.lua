return
{
    "ThePrimeagen/harpoon",

    branch = "harpoon2",
    dependencies = {
        "nvim-lua/plenary.nvim"
    },

    config = function()
        local harpoon = require('harpoon')
        
        -- IMPORTANT: Initialize Harpoon
        harpoon:setup()

        -- Define the toggle_telescope function
        local function toggle_telescope(harpoon_list)
            local telescope = require("telescope.builtin")
            local conf = require("telescope.config").values
            local file_paths = {}
            for _, item in ipairs(harpoon_list.items) do
                table.insert(file_paths, item.value)
            end

            telescope.find_files({
                prompt_title = "Harpoon",
                finder = require("telescope.finders").new_table({
                    results = file_paths,
                }),
                previewer = conf.file_previewer({}),
                sorter = conf.generic_sorter({}),
            })
        end

        -- Core Harpoon keymaps
        vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, 
            { desc = "Add file to Harpoon" })
        vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
            { desc = "Toggle Harpoon menu" })
        vim.keymap.set("n", "<leader>fl", function() toggle_telescope(harpoon:list()) end,
            { desc = "Open Harpoon in Telescope" })
        
        -- Navigation keymaps with better descriptions
        vim.keymap.set("n", "<C-p>", function() harpoon:list():prev() end,
            { desc = "Previous Harpoon file" })
        vim.keymap.set("n", "<C-n>", function() harpoon:list():next() end,
            { desc = "Next Harpoon file" })
        
        -- Alternative keymaps if Ctrl conflicts are problematic
        vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end,
            { desc = "Previous Harpoon file (alt)" })
        vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end,
            { desc = "Next Harpoon file (alt)" })
    end
}
