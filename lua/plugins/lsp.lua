return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "j-hui/fidget.nvim",
            "folke/neodev.nvim",
        },
        config = function()
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })

            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "rust_analyzer",
                    "pyright",  -- Python language server
                    "clangd",   -- Make sure this is included
                    "bashls",
                    "gopls",    -- Go language server
                },
                automatic_installation = true,
            })

            require("mason-registry").refresh(function()
                -- Install additional tools for development
                local mr = require("mason-registry")
                local packages = {
                    "clangd",       -- Make sure this is included
                    "codelldb",     -- LLDB-based debugger
                    "cpptools",     -- Microsoft C/C++ tools (includes cppdbg)
                    "gopls",        -- Go language server
                    "delve",        -- Go debugger
                    "eslint-lsp",   -- ESLint language server
                    "prettier",     -- Code formatter for JS/TS
                }

                for _, pkg_name in ipairs(packages) do
                    local pkg = mr.get_package(pkg_name)
                    if not pkg:is_installed() then
                        pkg:install()
                    end
                end
            end)

            local lspconfig = require("lspconfig")

            -- Lua LSP configuration
            lspconfig.lua_ls.setup({
                settings = {
                    Lua = {
                        runtime = { version = "Lua 5.1" },
                        diagnostics = {
                            globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                        },
                    },
                },
            })

            -- Python LSP configuration (pyright)
            lspconfig.pyright.setup({
                settings = {
                    python = {
                        analysis = {
                            typeCheckingMode = "basic",
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                            diagnosticMode = "workspace",
                        },
                        pythonPath = vim.fn.exepath("python3"),  -- Use Python 3
                    },
                },
            })

            -- C/C++ LSP configuration (clangd)
            lspconfig.clangd.setup({
                cmd = {
                    "clangd",
                    "--background-index",
                    "--suggest-missing-includes",
                    "--clang-tidy",
                    "--header-insertion=iwyu",
                },
                filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
                root_dir = function(fname)
                    return require("lspconfig.util").root_pattern(
                        "compile_commands.json",
                        "compile_flags.txt",
                        ".git"
                    )(fname) or vim.fn.getcwd()
                end,
                init_options = {
                    compilationDatabasePath = "build",
                },
            })

            -- Go LSP configuration (gopls)
            lspconfig.gopls.setup({
                cmd = {"gopls", "serve"},
                filetypes = {"go", "gomod", "gowork", "gotmpl"},
                root_dir = function(fname)
                    return require("lspconfig.util").root_pattern("go.work", "go.mod", ".git")(fname) or vim.fn.getcwd()
                end,
                settings = {
                    gopls = {
                        analyses = {
                            unusedparams = true,
                            shadow = true,
                        },
                        staticcheck = true,
                        gofumpt = true,
                        usePlaceholders = true,
                        completeUnimported = true,
                        matcher = "fuzzy",
                    },
                },
            })

            -- Set up keybindings for LSP functionality
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    -- Enable completion triggered by <c-x><c-o>
                    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                    -- Buffer local mappings.
                    local opts = { buffer = ev.buf }
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
                    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
                    vim.keymap.set('n', '<leader>wl', function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end, opts)
                    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
                    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                end,
            })
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "onsails/lspkind.nvim",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")

            require("luasnip/loaders/from_vscode").lazy_load()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-k>"] = cmp.mapping.select_prev_item(),
                    ["<C-j>"] = cmp.mapping.select_next_item(),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp", priority = 1000 },
                    { name = "tabnine", priority = 900 },  -- Add this line if not present
                    { name = "luasnip", priority = 800 },
                    { name = "buffer", priority = 700 },
                    { name = "path", priority = 600 },
                }),
                formatting = {
                    format = lspkind.cmp_format({
                        maxwidth = 50,
                        ellipsis_char = "...",
                    }),
                },
            })
        end,
    }
}
