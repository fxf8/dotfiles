return {
    'VonHeikemen/lsp-zero.nvim',
    dependencies = {
        -- LSP Support
        'neovim/nvim-lspconfig',
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',

        -- Autocompletion
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lua',
        -- Snippets
        'L3MON4D3/LuaSnip',
        'rafamadriz/friendly-snippets',
    },

    config = function()
        vim.opt.signcolumn = 'yes'

        local mason = require("mason")
        local lsp = require("lsp-zero")
        local cmp = require("cmp")

        mason.setup()

        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        local lspconfig = require("lspconfig")

        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'vsnip' },
        })

        lspconfig.ruff.setup()
        lspconfig.clangd.setup()

        lsp.on_attach(function(client, bufnr)
            local options = { buffer = bufnr, remap = false }

            vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, options)
            vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, options)
            vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, options)
            vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, options)
            vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, options)
            vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, options)
            vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, options)
            vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, options)
            vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, options)
            vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, options)
            vim.keymap.set("n", "<leader>lzf", function() vim.lsp.buf.format() end, options)
            vim.keymap.set("v", "<leader>lzf", function() vim.lsp.buf.format() end, options)

            print("it has attached")
        end)
    end
}
