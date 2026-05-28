return {
    'mrcjkb/rustaceanvim',
    -- To avoid being surprised by breaking changes,
    -- I recommend you set a version range
    version = '^9',
    -- This plugin implements proper lazy-loading (see :h lua-plugin-lazy).
    -- No need for lazy.nvim to lazy-load it.
    lazy = false,

    config = function()
        -- 1. Grab your existing capabilities from cmp
        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        -- 2. Define the on_attach that matches your lsp.lua exactly
        local rust_on_attach = function(client, bufnr)
            local buf_map = function(mode, lhs, rhs, desc)
                vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
            end

            -- Standard LSP Mappings from your lsp.lua
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

            -- Inlay Hints toggles from your lsp.lua
            buf_map('n', '<leader>lhe', function() vim.lsp.inlay_hint.enable(true, { bufnr = bufnr }) end,
                'Enable inlay hints')
            buf_map('n', '<leader>lhd', function() vim.lsp.inlay_hint.enable(false, { bufnr = bufnr }) end,
                'Disable inlay hints')
        end

        -- 3. Configure rustaceanvim
        vim.g.rustaceanvim = {
            server = {
                on_attach = rust_on_attach,
                capabilities = capabilities,
                default_settings = {
                    -- This is exactly what was in your lsp.lua ["rust-analyzer"] table
                    ['rust-analyzer'] = {
                        checkOnSave = {
                            enable = true,
                            command = "clippy",
                            extraArgs = { "--no-deps" },
                        },
                        cargo = {
                            allFeatures = true,
                            loadOutDirsFromCheck = true,
                            autoreload = true,
                            useRustcWrapperForBuildScripts = true,
                        },
                        procMacro = { enable = true },
                        files = {
                            -- enableStandaloneProjects = true,
                        }
                    },
                },
            },
            -- DAP Configuration (Crucial for debugging)
            dap = {
                -- This will automatically use the codelldb you installed via Mason
            },
        }
    end
}
