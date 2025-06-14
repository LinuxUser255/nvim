return {
    -- Python-specific plugins
    {
        "mfussenegger/nvim-dap-python",
        -- Remove the ft = "python" line to ensure it loads regardless of filetype
        dependencies = {
            "mfussenegger/nvim-dap",
        },
        config = function()
            require("dap-python").setup("python3")
            -- For debugging Python code
        end,
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio", -- Add this missing dependency
        },
        config = function()
            require("dapui").setup()
            -- For a nice debugging UI
        end,
    },
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-neotest/neotest-python",
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-python")({
                        dap = { justMyCode = false },
                        python = "python3",
                        runner = "pytest",
                    })
                }
            })
            -- For running Python tests
        end,
    }
}