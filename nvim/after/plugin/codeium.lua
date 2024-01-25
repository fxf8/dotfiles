local accept = function() return vim.fn['codeium#Accept']() end
local cycle1 = function() return vim.fn['codeium#CycleCompletions'](1) end
local cycle2 = function() return vim.fn['codeium#CycleCompletions'](-1) end
local clear = function() return vim.fn['codeium#Clear']() end

local opts = { expr = true, silent = true }

vim.keymap.set('i', '<C-J>', accept, opts)
vim.keymap.set('i', '<C-H>', cycle1, opts)
vim.keymap.set('i', '<C-K>', cycle2, opts)
vim.keymap.set('i', '<C-X>', clear, opts)
