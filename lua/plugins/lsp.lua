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
                    "rust_analyzer", -- installed via mason so rustaceanvim can use the binary,
                                     -- but not auto-enabled here (see automatic_enable below)
                    "pyright",  -- Python language server
                    "clangd",   -- Clangd-based C/C++ language server
                    "bashls",   -- Bash language server
                    "gopls",    -- Go language server
                },
                automatic_installation = true,
                -- rustaceanvim (plugins/rust.lua) starts rust-analyzer itself, and lua_ls/
                -- pyright/clangd/gopls are configured and enabled manually below via
                -- vim.lsp.config()/vim.lsp.enable(). Without this exclusion, mason-lspconfig
                -- would also auto-enable them, producing a second, competing client for each.
                automatic_enable = { exclude = { "rust_analyzer", "lua_ls", "pyright", "clangd", "gopls" } },
            })

            require("mason-registry").refresh(function()
                -- Install additional tools for development
                local mr = require("mason-registry")
                local packages = {
                    "clangd",       -- Include this
                    "codelldb",     -- LLDB-based debugger
                    "cpptools",     -- C/C++ tools (includes cppdbg)
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

            -- Enhanced on_attach function with better inlay hint handling
            local function on_attach(client, bufnr)
                -- Enable inlay hints if supported, with error handling
                -- if client.server_capabilities.inlayHintProvider then
                --     local ok, _ = pcall(function()
                --         vim.lsp.inlay_hint.enable(bufnr, true)
                --     end)
                --     if not ok then
                --         vim.notify("Failed to enable inlay hints for " .. client.name, vim.log.levels.WARN)
                --     end
                -- end
            end

            -- Lua LSP configuration
            vim.lsp.config('lua_ls', {
                settings = {
                    Lua = {
                        runtime = { version = "Lua 5.1" },
                        diagnostics = {
                            globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                        },
                    },
                },
                on_attach = on_attach,
            })
            vim.lsp.enable('lua_ls')

            -- Rust is intentionally NOT set up here: rustaceanvim (see plugins/rust.lua)
            -- owns the rust-analyzer client. Also starting it via lspconfig here would
            -- attach two competing rust-analyzer clients to every Rust buffer.

            -- Python LSP configuration (pyright)
            vim.lsp.config('pyright', {
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
                on_attach = on_attach,
            })
            vim.lsp.enable('pyright')

            -- C/C++ LSP configuration (clangd)
            vim.lsp.config('clangd', {
                cmd = {
                    "clangd",
                    "--background-index",
                    "--suggest-missing-includes",
                    "--clang-tidy",
                    "--header-insertion=iwyu",
                },
                filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
                root_markers = { "compile_commands.json", "compile_flags.txt", ".git" },
                init_options = {
                    compilationDatabasePath = "build",
                },
                on_attach = on_attach,
            })
            vim.lsp.enable('clangd')

            -- Go LSP configuration (gopls)
            vim.lsp.config('gopls', {
                cmd = {"gopls", "serve"},
                filetypes = {"go", "gomod", "gowork", "gotmpl"},
                root_markers = { "go.work", "go.mod", ".git" },
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
                        hints = {
                            assignVariableTypes = true,
                            compositeLiteralFields = true,
                            compositeLiteralTypes = true,
                            constantValues = true,
                            functionTypeParameters = true,
                            parameterNames = true,
                            rangeVariableTypes = true,
                        },
                    },
                },
                on_attach = on_attach,
            })
            vim.lsp.enable('gopls')

            -- Set up keybindings for LSP functionality
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    -- Enable completion triggered by <c-x><c-o>
                    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                    -- rustaceanvim (plugins/rust.lua) already sets K and <leader>ca for its
                    -- rust-analyzer client, via vim.g.rustaceanvim.server.on_attach. Its
                    -- on_attach runs before this LspAttach autocmd, so without this guard
                    -- the generic mappings below would silently overwrite those.
                    local client = vim.lsp.get_client_by_id(ev.data.client_id)
                    local is_rust_analyzer = client and (client.name == 'rust-analyzer' or client.name == 'rust_analyzer')

                    -- Buffer local mappings.
                    local opts = { buffer = ev.buf }
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
                    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
                    vim.keymap.set('n', '<leader>wl', function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end, opts)
                    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
                    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

                    if not is_rust_analyzer then
                        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                        vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
                    end

                    -- Add keymap to toggle inlay hints
                    -- vim.keymap.set('n', '<leader>ih', function()
                    --     vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled(0))
                    -- end, opts)
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
                    -- Smart Tab mapping that works with indentation
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            -- If completion menu is visible, confirm selection
                            -- This will insert the selected item (including Tabnine suggestions)
                            cmp.confirm({ select = true })
                        elseif luasnip.expand_or_jumpable() then
                            -- If snippet is expandable/jumpable, do that
                            luasnip.expand_or_jump()
                        else
                            -- Otherwise, do normal Tab behavior (indentation)
                            -- For Rust files, check if we're at the start of a line after {
                            local line = vim.api.nvim_get_current_line()
                            local col = vim.fn.col('.') - 1
                            local is_rust = vim.bo.filetype == 'rust'
                            
                            -- Only insert spaces if not immediately after an opening brace
                            -- This prevents double-indentation in Rust
                            if is_rust and col == 0 and string.match(line, '^%s*$') then
                                -- Empty line in Rust, let smartindent handle it
                                fallback()
                            else
                                fallback()
                            end
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp", priority = 1000 },
                    -- { name = "tabnine", priority = 900 }, -- disabled: tabnine deprecated/unsupported, was causing startup hangs
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
