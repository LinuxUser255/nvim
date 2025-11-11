return {
    -- TypeScript/JavaScript specific plugins
    -- macOS branch: typescript-tools.nvim disabled due to Neovim 0.11 compatibility issues
    -- {
    --     "pmizio/typescript-tools.nvim",
    --     enabled = false,
    -- },
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
