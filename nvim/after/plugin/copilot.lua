--[[
 ________  ________  ________  ___  ___       ________  _________
|\   ____\|\   __  \|\   __  \|\  \|\  \     |\   __  \|\___   ___\
\ \  \___|\ \  \|\  \ \  \|\  \ \  \ \  \    \ \  \|\  \|___ \  \_|
 \ \  \    \ \  \\\  \ \   ____\ \  \ \  \    \ \  \\\  \   \ \  \
  \ \  \____\ \  \\\  \ \  \___|\ \  \ \  \____\ \  \\\  \   \ \  \
   \ \_______\ \_______\ \__\    \ \__\ \_______\ \_______\   \ \__\
    \|_______|\|_______|\|__|     \|__|\|_______|\|_______|    \|__|
]]
--

--[[
local cmp = require('cmp')

--[[
vim.api.nvim_set_keymap("i", "<M-j>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
vim.api.nvim_set_keymap("i", "<M-p>", 'copilot#Previous()', { silent = true, expr = true })
vim.api.nvim_set_keymap("i", "<M-n>", 'copilot#Next()', { silent = true, expr = true })
vim.api.nvim_set_keymap("i", "<M-l>", 'copilot#AcceptLine()', { silent = true, expr = true })
vim.api.nvim_set_keymap("i", "<M-w>", 'copilot#AcceptWord()', { silent = true, expr = true })
vim.api.nvim_set_keymap("i", "<M-d>", 'copilot#Dismiss()', { silent = true, expr = true })
vim.api.nvim_set_keymap("i", "<M-s>", 'copilot#Suggest()', { silent = true, expr = true })
]]
--

local opts = { noremap = true, silent = true, expr = true, replace_keycodes = false }

vim.keymap.set('i', '<M-j>', 'copilot#Accept()', opts)
vim.keymap.set('i', '<M-p>', 'copilot#Previous()', opts)
vim.keymap.set('i', '<M-n>', 'copilot#Next()', opts)
vim.keymap.set('i', '<M-l>', 'copilot#AcceptLine()', opts)
vim.keymap.set('i', '<M-w>', 'copilot#AcceptWord()', opts)
vim.keymap.set('i', '<M-d>', 'copilot#Dismiss()', opts)
vim.keymap.set('i', '<M-s>', 'copilot#Suggest()', opts)

vim.keymap.set('n', '<leader>co',
    function()
        vim.cmd('Copilot panel')
    end,
    {}
)
