return
{
    "ThePrimeagen/harpoon",

    branch = "harpoon2",
    dependencies = {
        "nvim-lua/plenary.nvim"
    },

    config = function()
        local harpoon = require('harpoon')

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

        vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
        vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
        vim.keymap.set("n", "<leader>fl", function() toggle_telescope(harpoon:list()) end,
            { desc = "Open harpoon window" })
            -- Change the keympa below at some point.
            vim.keymap.set("n", "<C-p>", function() harpoon:list():prev() end)
        vim.keymap.set("n", "<C-n>", function() harpoon:list():next() end)
    end
}
