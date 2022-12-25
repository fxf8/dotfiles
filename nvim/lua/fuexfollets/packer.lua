-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
    -- Packer can manage itself
    use('wbthomason/packer.nvim')

    -- LSP things
    use('williamboman/nvim-lsp-installer')
    use('neovim/nvim-lspconfig')
    use { 'neoclide/coc.nvim', branch = 'release' }


    use('hrsh7th/nvim-compe')
    use('RRethy/vim-hexokinase')

    -- Color schemes
    use('folke/tokyonight.nvim')
    use('sickill/vim-monokai')
    use('Mofiqul/dracula.nvim')

    use('andweeb/presence.nvim') -- Discord presence

    use('airblade/vim-gitgutter') -- Git diff within vim

    use { -- Pet duck that walk around the code
        'tamton-aquib/duck.nvim',
        config = function()
            vim.keymap.set('n', '<leader>dd', function() require("duck").hatch() end, {})
            vim.keymap.set('n', '<leader>dk', function() require("duck").cook() end, {})
        end
    }

    use {
        'krady21/compiler-explorer.nvim', requires = { 'nvim-lua/plenary.nvim' }
    }

     use {
        'nvim-treesitter/nvim-treesitter',
        run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
    }

end)
