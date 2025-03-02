local wk = require("which-key")
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set('n', "<leader>ha", mark.add_file)
vim.keymap.set('n', "<leader>hr", mark.rm_file)
vim.keymap.set('n', "<leader>ho", ui.toggle_quick_menu)

vim.keymap.set('n', "<leader>hn", ui.nav_next)
vim.keymap.set('n', "<leader>hp", ui.nav_prev)
vim.keymap.set('n', "<leader>hs", ui.select_menu_item)

wk.add({
    { "<leader>h",  group = "Harpoon" },
    { "<leader>ha", desc = "Add file" },
    { "<leader>hr", desc = "Remove file" },
    { "<leader>ho", desc = "Toggle quick menu" },
    { "<leader>hn", desc = "Navigate to next file" },
    { "<leader>hp", desc = "Navigate to previous file" },
    { "<leader>hs", desc = "Select menu item" },
})
