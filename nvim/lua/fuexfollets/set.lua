vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.errorbells = false

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = true

vim.opt.swapfile = false

vim.g.mapleader = " "

vim.keymap.set("n", "<leader>w", vim.cmd.w) -- Write to current file
vim.keymap.set("n", "<leader>W", vim.cmd.wall) -- Write to all

vim.keymap.set("n", "<leader>q", vim.cmd.q) -- Quit
vim.keymap.set("n", "<leader>Q", function() vim.cmd("q!") end) -- Quit without saving
