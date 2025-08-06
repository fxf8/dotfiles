return {
    -- LSP core
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'folke/lazydev.nvim',
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'hrsh7th/nvim-cmp',
            'hrsh7th/cmp-nvim-lsp',
            'L3MON4D3/LuaSnip',
            'folke/which-key.nvim',
        },
        config = function()
            local mason = require('mason')
            local mason_lspconfig = require('mason-lspconfig')
            local lspconfig = require('lspconfig')
            -- local cmp = require('cmp')
            local cmp_nvim_lsp = require('cmp_nvim_lsp')
            local wk = require('which-key')

            mason.setup()

            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                cmp_nvim_lsp.default_capabilities())

            local on_attach = function(_, bufnr)
                local buf_map = function(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
                end

                buf_map('n', 'gd', vim.lsp.buf.definition, 'Go to Definition')
                buf_map('n', 'K', vim.lsp.buf.hover, 'Hover Documentation')
                buf_map('n', '<leader>ln', vim.lsp.buf.rename, 'Rename Symbol')
                buf_map('n', '<leader>la', vim.lsp.buf.code_action, 'Code Action')
                buf_map('n', '<leader>lf', vim.lsp.buf.format, 'Format Code')
                buf_map('n', '<leader>ly', vim.lsp.buf.document_symbol, 'Document Symbols')
                buf_map('n', '<leader>ls', vim.lsp.buf.workspace_symbol, 'Workspace Symbols')
                buf_map('n', '<leader>ld', vim.diagnostic.open_float, 'Open Diagnostics')
                buf_map('n', '<leader>lr', vim.lsp.buf.references, 'Find References')
                buf_map('n', '<leader>li', vim.lsp.buf.implementation, 'Go to Implementation')

                local enable_inlay_hints = function()
                    if vim.lsp.inlay_hint then
                        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                    end
                end

                local disable_inlay_hints = function()
                    if vim.lsp.inlay_hint then
                        vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
                    end
                end

                buf_map('n', '<leader>lhe', enable_inlay_hints, 'Enable inlay hints')
                buf_map('n', '<leader>lhd', disable_inlay_hints, 'Disable inlay hints')

                wk.add({
                    { "<leader>l",   group = "LSP Actions" },
                    { "<leader>ln",  desc = "Rename symbol" },
                    { "<leader>la",  desc = "Code actions" },
                    { "<leader>lf",  desc = "Format code" },
                    { "<leader>ly",  desc = "Document Symbols" },
                    { "<leader>ls",  desc = "Workspace symbol" },
                    { "<leader>ld",  desc = "Open diagnostics" },
                    { "<leader>lr",  desc = "Find references" },
                    { "<leader>li",  desc = "Go to Implementation" },
                    { "<leader>lh",  group = "LSP Inlay Hints" },
                    { "<leader>lhe", desc = "Enable inlay hints" },
                    { "<leader>lhd", desc = "Disable inlay hints" },
                })
            end

            vim.lsp.config("docker_compose_language_service",
                {
                    on_attach = on_attach,
                    capabilities = capabilities,
                    settings = {
                    }
                })
            vim.lsp.config("ts_ls", {
                on_attach = function(client, bufnr)
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false
                    on_attach(client, bufnr) -- reuse your common setup
                end,
                capabilities = capabilities
            })
            vim.lsp.config("cssls", { on_attach = on_attach, capabilities = capabilities, })
            vim.lsp.config("jsonls", { on_attach = on_attach, capabilities = capabilities, })
            vim.lsp.config("dockerls", { on_attach = on_attach, capabilities = capabilities, })
            vim.lsp.config("taplo", { on_attach = on_attach, capabilities = capabilities, })
            vim.lsp.config("pyright", { on_attach = on_attach, capabilities = capabilities, })
            vim.lsp.config("ruff", { on_attach = on_attach, capabilities = capabilities, })
            vim.lsp.config("lua_ls", { on_attach = on_attach, capabilities = capabilities, })
            vim.lsp.config("rust_analyzer", {
                on_attach = on_attach,
                capabilities = capabilities,
                settings = {
                    ["rust-analyzer"] = {
                        checkOnSave = {
                            enable = true,
                            command = "clippy",
                            extraArgs = { "--no-deps" },
                        },
                        cargo = {
                            allFeatures = true,
                            -- Enable support for standalone files:
                            loadOutDirsFromCheck = true,
                            -- 👇 this enables rust-analyzer to work without Cargo.toml
                            autoreload = true,
                            -- 👇 this is the key setting you need:
                            -- allows rust-analyzer to work in files not in a project
                            useRustcWrapperForBuildScripts = true,
                        },
                        procMacro = { enable = true },
                        files = {
                            -- 👇 allow single file mode
                            enableStandaloneProjects = true,
                        }
                    },
                },
            })

            mason_lspconfig.setup({
                ensure_installed = {
                    "pyright", "ruff", "lua_ls", "rust_analyzer"
                },
            })

            vim.diagnostic.config({
                virtual_text = true,
                -- virtual_lines = true,
                signs = true,
                update_in_insert = false,
                underline = true,
                severity_sort = true,
                float = { border = 'rounded', source = true },
            })

            vim.opt.signcolumn = 'yes'
            --[[ stashed for later

            clangd = {
                cmd = { 'clangd', '--background-index', '--clang-tidy', '--header-insertion=iwyu', '--completion-style=detailed' },
                filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'h', 'hpp', 'm', 'mm', 'cc', 'hh', 'cxx', 'hxx' },
                root_dir = lspconfig.util.root_pattern('compile_commands.json', 'compile_flags.txt', '.git'),
            },
            ]]
        end,
    },

    -- Completion
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'L3MON4D3/LuaSnip',
        },
        config = function()
            local cmp = require('cmp')
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                }),
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                },
            })
        end,
    },

    -- Optional: Expand Rust Macros
    {
        'rust-lang/rust.vim',
        config = function()
            vim.api.nvim_create_user_command('ExpandMacro', function()
                vim.lsp.buf_request_all(0, 'rust-analyzer/expandMacro',
                    vim.lsp.util.make_position_params(),
                    function(result)
                        vim.cmd('vsplit')
                        local buf = vim.api.nvim_create_buf(false, true)
                        vim.api.nvim_win_set_buf(0, buf)
                        if result then
                            vim.api.nvim_set_option_value('filetype', 'rust', { buf = 0 })
                            for _, res in pairs(result) do
                                if res and res.result and res.result.expansion then
                                    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(res.result.expansion, '\n'))
                                else
                                    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { 'No expansion available.' })
                                end
                            end
                        else
                            vim.api.nvim_buf_set_lines(buf, 0, -1, false, { 'Error: No result returned.' })
                        end
                    end)
            end, {})
        end,
    },

    {
        "nvimtools/none-ls.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            local null_ls = require("null-ls")

            null_ls.setup({
                sources = {
                    -- Add more if needed
                    null_ls.builtins.formatting.prettier,
                },
                on_attach = function(client, bufnr)
                    -- Only format on save if the client supports it
                    if client.supports_method("textDocument/formatting") then
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            buffer = bufnr,
                            callback = function()
                                vim.lsp.buf.format({
                                    bufnr = bufnr,
                                    filter = function(format_client)
                                        -- Only use null-ls (prettier) for formatting
                                        return format_client.name == "null-ls"
                                    end,
                                })
                            end,
                        })
                    end
                end,
            })
        end,
    }

}
