return {
    -- TypeScript/JavaScript specific plugins
    {
        "pmizio/typescript-tools.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "neovim/nvim-lspconfig",
        },
        -- Remove the ft restriction and use event instead
        event = { "BufReadPre", "BufNewFile" },
        -- Keep the filetypes for conditional setup
        filetypes = {
            "typescript",
            "javascript",
            "typescriptreact",
            "javascriptreact",
            "typescript.tsx",
            "javascript.jsx",
        },
        opts = {
            settings = {
                -- spawn additional tsserver instance to calculate diagnostics on it
                separate_diagnostic_server = true,
                -- "change"|"insert_leave" determine when the client asks the server about diagnostic
                publish_diagnostic_on = "insert_leave",
                -- expose all actions as code actions
                expose_as_code_action = "all",
                -- enhanced completion experience
                complete_function_calls = true,
                include_completions_with_insert_text = true,
                -- CodeLens
                code_lens = "all",
                -- Auto-import settings
                auto_import_suggestions = {
                    enable = true,
                },
            },
        },
        config = function(_, opts)
            require("typescript-tools").setup(opts)

            -- Adding TypeScript specific keymaps - modify to check filetype
            vim.api.nvim_create_autocmd("FileType", {
                pattern = {"typescript", "javascript", "typescriptreact", "javascriptreact"},
                callback = function()
                    local buffer = vim.api.nvim_get_current_buf()
                    vim.keymap.set("n", "<leader>toi", ":TSToolsOrganizeImports<CR>", { buffer = buffer })
                    vim.keymap.set("n", "<leader>tru", ":TSToolsRemoveUnused<CR>", { buffer = buffer })
                    vim.keymap.set("n", "<leader>tfi", ":TSToolsFixAll<CR>", { buffer = buffer })
                    vim.keymap.set("n", "<leader>tai", ":TSToolsAddMissingImports<CR>", { buffer = buffer })
                    vim.keymap.set("n", "<leader>tsu", ":TSToolsSortImports<CR>", { buffer = buffer })
                    vim.keymap.set("n", "<leader>trf", ":TSToolsRenameFile<CR>", { buffer = buffer })
                    vim.keymap.set("n", "<leader>tgd", ":TSToolsGoToSourceDefinition<CR>", { buffer = buffer })
                end,
            })
        end,
    },
    {
        "dmmulroy/tsc.nvim",
        cmd = { "TSC" },
        opts = {
            auto_open_qflist = true,
            enable_progress_notifications = true,
            hide_progress_notifications_from_history = true,
            spinner = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },
            pretty_errors = true,
        },
    },
    {
        "dmmulroy/ts-error-translator.nvim",
        ft = {
            "typescript",
            "javascript",
            "typescriptreact",
            "javascriptreact",
        },
        opts = {},
    },
    {
        "marilari88/neotest-vitest",
        dependencies = {
            "nvim-neotest/neotest",
        },
    },
    {
        "nvim-neotest/neotest",
        optional = true,
        dependencies = {
            "marilari88/neotest-vitest",
        },
        opts = {
            adapters = {
                ["neotest-vitest"] = {},
            },
        },
    },
    {
        "axelvc/template-string.nvim",
        ft = {
            "typescript",
            "javascript",
            "typescriptreact",
            "javascriptreact",
        },
        opts = {
            filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
            jsx_brackets = true,
            remove_template_string = false,
            restore_quotes = {
                normal = [[']],
                jsx = [["]],
            },
        },
    },
}
