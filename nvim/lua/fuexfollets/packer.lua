-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]


return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-compe'
  use 'folke/tokyonight.nvim'
  use 'dmerejkowsky/vim-ale'
  use 'RRethy/vim-hexokinase'

  use {
    'krady21/compiler-explorer.nvim', requires = { 'nvim-lua/plenary.nvim' }
  }
  
end)

