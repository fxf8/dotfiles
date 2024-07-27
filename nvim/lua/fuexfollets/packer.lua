-- This file can be loaded by calling `lua require('plugins')` from your init.vim
-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
    -- Packer can manage itself
    use('wbthomason/packer.nvim')

    use('folke/neodev.nvim')
    use('norcalli/nvim-colorizer.lua')
    use('vim-scripts/AnsiEsc.vim')

    use('jbyuki/instant.nvim')
    use('jose-elias-alvarez/null-ls.nvim')
    -- use('github/copilot.vim')
    use('Exafunction/codeium.vim')
    use { "akinsho/toggleterm.nvim", tag = '*', config = function()
        require("toggleterm").setup()
    end }

    -- Color schemes
    use('sickill/vim-monokai')
    use('Mofiqul/dracula.nvim')
    use('xiyaowong/nvim-transparent') -- Transparent background
    use('folke/tokyonight.nvim')
    use { 'AlphaTechnolog/pywal.nvim', as = 'pywal' }
    use('BooleanCube/keylab.nvim') -- Keybindings lab
    use('rose-pine/neovim')        -- Rose Pine color scheme

    -- use('airblade/vim-gitgutter')    -- Git diff within vim
    use('tpope/vim-fugitive') -- Git wrapper
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    -- install without yarn or npm
    use({
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
    })

    use('turbio/bracey.vim')             -- Browser based live HTML/CSS/JS preview

    use('xuhdev/vim-latex-live-preview') -- Live preview for latex

    -- use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install", setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, })

    use('mbbill/undotree') -- undotree

    use {
        'nvim-treesitter/nvim-treesitter',
        run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
    }

    use { -- Telescope
        'nvim-telescope/telescope.nvim', tag = '0.1.4',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    use('theprimeagen/harpoon') -- Primeagen Harpoon
    -- use('stevearc/oil.nvim') -- Filestructure management
    use('nvim-tree/nvim-web-devicons')
    use { -- LSP
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },
            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    }
    use('Issafalcon/lsp-overloads.nvim')

    use {
        'akinsho/flutter-tools.nvim',
        requires = {
            'nvim-lua/plenary.nvim',
            'stevearc/dressing.nvim', -- optional for vim.ui.select
        },
    }

    --[[
    use {
        "rest-nvim/rest.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            require("rest-nvim").setup({
                -- Open request results in a horizontal split
                result_split_horizontal = false,
                -- Keep the http file buffer above|left when split horizontal|vertical
                result_split_in_place = false,
                -- Skip SSL verification, useful for unknown certificates
                skip_ssl_verification = false,
                -- Encode URL before making request
                encode_url = true,
                -- Highlight request on run
                highlight = {
                    enabled = true,
                    timeout = 150,
                },
                result = {
                    -- toggle showing URL, HTTP info, headers at top the of result window
                    show_url = true,
                    -- show the generated curl command in case you want to launch
                    -- the same request via the terminal (can be verbose)
                    show_curl_command = false,
                    show_http_info = true,
                    show_headers = true,
                    -- executables or functions for formatting response body [optional]
                    -- set them to false if you want to disable them
                    formatters = {
                        json = "jq",
                        html = function(body)
                            return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
                        end
                    },
                },
                -- Jump to request line on run
                jump_to_request = false,
                env_file = '.env',
                custom_dynamic_variables = {},
                yank_dry_run = true,
            })
        end
    }
    ]]
    --

    use('nvim-neotest/nvim-nio')
    use('lvimuser/lsp-inlayhints.nvim')
    use("mfussenegger/nvim-dap")
    use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } }
    use("theHamsta/nvim-dap-virtual-text")
    use("jay-babu/mason-nvim-dap.nvim")
    use('Civitasv/cmake-tools.nvim')

    -- use({
    --    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    --    config = function()
    --        require("lsp_lines").setup()
    --    end,
    -- })
    use('Maan2003/lsp_lines.nvim')
end)
