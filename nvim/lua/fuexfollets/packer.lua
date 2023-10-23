-- This file can be loaded by calling `lua require('plugins')` from your init.vim
-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
    -- Packer can manage itself
    use('wbthomason/packer.nvim')

    use('RRethy/vim-hexokinase')

    use('folke/neodev.nvim')

    use('jose-elias-alvarez/null-ls.nvim')
    use('github/copilot.vim')
    use { "akinsho/toggleterm.nvim", tag = '*', config = function()
        require("toggleterm").setup()
    end }
    use('p00f/godbolt.nvim')

    use('azadkuh/vim-cmus')

    -- Color schemes
    use('sickill/vim-monokai')
    use('Mofiqul/dracula.nvim')
    use('xiyaowong/nvim-transparent') -- Transparent background
    use('folke/tokyonight.nvim')
    use { 'AlphaTechnolog/pywal.nvim', as = 'pywal' }

    use { 'tamton-aquib/keys.nvim' } -- Screenkey equivalient for nvim
    use('BooleanCube/keylab.nvim')   -- Keybindings lab

    use('airblade/vim-gitgutter')    -- Git diff within vim
    use('tpope/vim-fugitive')        -- Git wrapper
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    -- install without yarn or npm
    use({
        "iamcco/markdown-preview.nvim",
        run = function() vim.fn["mkdp#util#install"]() end,
    })
    use { 'dccsillag/magma-nvim', run = ':UpdateRemotePlugins' }

    use('turbio/bracey.vim')             -- Browser based live HTML/CSS/JS preview

    use('xuhdev/vim-latex-live-preview') -- Live preview for latex

    -- use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install", setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, })

    use('mbbill/undotree') -- undotree

    use {
        'nvim-treesitter/nvim-treesitter',
        run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
    }

    use { -- Telescope
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    use { -- Pet duck that walk around the code
        'tamton-aquib/duck.nvim',
        config = function()
            vim.keymap.set('n', '<leader>dd', function() require("duck").hatch() end, {})
            vim.keymap.set('n', '<leader>dk', function() require("duck").cook() end, {})
        end
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

    -- use({
    --    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    --    config = function()
    --        require("lsp_lines").setup()
    --    end,
    -- })
    use('Maan2003/lsp_lines.nvim')
end)
