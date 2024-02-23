--[[
 ________  ________  ________  _______   ___  ___  ___  _____ ______
|\   ____\|\   __  \|\   ___ \|\  ___ \ |\  \|\  \|\  \|\   _ \  _   \
\ \  \___|\ \  \|\  \ \  \_|\ \ \   __/|\ \  \ \  \\\  \ \  \\\__\ \  \
 \ \  \    \ \  \\\  \ \  \ \\ \ \  \_|/_\ \  \ \  \\\  \ \  \\|__| \  \
  \ \  \____\ \  \\\  \ \  \_\\ \ \  \_|\ \ \  \ \  \\\  \ \  \    \ \  \
   \ \_______\ \_______\ \_______\ \_______\ \__\ \_______\ \__\    \ \__\
    \|_______|\|_______|\|_______|\|_______|\|__|\|_______|\|__|     \|__|
]]
   --

--[[
local accept = function() return vim.fn['codeium#Accept']() end
local cycle1 = function() return vim.fn['codeium#CycleCompletions'](1) end
local cycle2 = function() return vim.fn['codeium#CycleCompletions'](-1) end
local clear = function() return vim.fn['codeium#Clear']() end

local opts = { expr = true, silent = true }

vim.keymap.set('i', '<C-J>', accept, opts)
vim.keymap.set('i', '<C-H>', cycle1, opts)
vim.keymap.set('i', '<C-K>', cycle2, opts)
vim.keymap.set('i', '<C-X>', clear, opts)
]]--
