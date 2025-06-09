return {
    -- Go-specific plugins
    {
        "ray-x/go.nvim",
        dependencies = {
            "ray-x/guihua.lua",
            "neovim/nvim-lspconfig",
            "nvim-treesitter/nvim-treesitter",
            "mfussenegger/nvim-dap",
        },
        config = function()
            require("go").setup({
                -- Go configuration options
                go = "go", -- Go command
                goimport = "gopls", -- goimport command, can be gopls[default] or goimport
                fillstruct = "gopls", -- can be nil (use fillstruct, slower) or gopls
                gofmt = "gofumpt", -- gofmt cmd,
                max_line_len = 120, -- max line length in goline format
                tag_transform = false, -- tag_transfer  check gomodifytags for details
                test_template = "", -- default to testify if not set; g:go_nvim_tests_template  check gotests for details
                test_template_dir = "", -- default to nil if not set; g:go_nvim_tests_template_dir  check gotests for details
                comment_placeholder = "", -- comment_placeholder your cool placeholder e.g. ﳑ
                icons = { breakpoint = "🧘", currentpos = "🏃" },
                verbose = false, -- output loginf in messages
                lsp_cfg = true, -- true: use non-default gopls setup specified in go/lsp.lua
                lsp_gofumpt = true, -- true: set default gofmt in gopls format to gofumpt
                lsp_on_attach = true, -- if a on_attach function provided:  attach on_attach function to gopls
                lsp_keymaps = true, -- set to false to disable gopls/lsp keymap
                lsp_codelens = true, -- set to false to disable codelens, true by default, you can use a function
                lsp_diag_hdlr = true, -- hook lsp diag handler
                lsp_diag_virtual_text = { space = 0, prefix = "" }, -- virtual text setup
                lsp_diag_signs = true,
                lsp_diag_update_in_insert = false,
                lsp_document_formatting = true,
                -- set to true: use gopls to format
                -- false if you want to use other formatter tool(e.g. efm, nulls)
                lsp_inlay_hints = {
                    enable = true,
                    -- Only show inlay hints for the current line
                    only_current_line = false,
                    -- Event which triggers a refersh of the inlay hints.
                    -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
                    -- not that this may cause higher CPU usage.
                    -- This option is only respected when only_current_line and
                    -- autoSetHints both are true.
                    only_current_line_autocmd = "CursorHold",
                    -- whether to show variable name before type hints with the inlay hints or not
                    -- default: false
                    show_variable_name = true,
                    -- prefix for parameter hints
                    parameter_hints_prefix = " ",
                    show_parameter_hints = true,
                    -- prefix for all the other hints (type, chaining)
                    other_hints_prefix = "=> ",
                }
            })
        end,
    },
}