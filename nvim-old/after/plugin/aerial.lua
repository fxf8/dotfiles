local aerial = require("aerial")
local wk = require("which-key")

aerial.setup()

vim.keymap.set("n", "<leader>at", function() vim.cmd("AerialToggle") end, {})
vim.keymap.set("n", "<leader>ao", function() vim.cmd("AerialOpen") end, {})
vim.keymap.set("n", "<leader>ac", function() vim.cmd("AerialClose") end, {})
vim.keymap.set("n", "<leader>ajn", function() vim.cmd("AerialNext") end, {})
vim.keymap.set("n", "<leader>ajp", function() vim.cmd("AerialPrev") end, {})

wk.add({
    { "<leader>a",   group = "Aerial" },
    { "<leader>at",  desc = "Toggle" },
    { "<leader>ao",  desc = "Open" },
    { "<leader>ac",  desc = "Close" },
    { "<leader>ajn", desc = "Jump to Next symbol" },
    { "<leader>ajp", desc = "Jump to Previous symbol" },
})
