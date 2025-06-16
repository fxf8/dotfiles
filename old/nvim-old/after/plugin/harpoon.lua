local wk = require("which-key")
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set('n', "<leader>fa", mark.add_file)
vim.keymap.set('n', "<leader>fr", mark.rm_file)
vim.keymap.set('n', "<leader>fo", ui.toggle_quick_menu)

vim.keymap.set('n', "<leader>fn", ui.nav_next)
vim.keymap.set('n', "<leader>fp", ui.nav_prev)
vim.keymap.set('n', "<leader>fs", ui.select_menu_item)

wk.add({
    { "<leader>f",  group = "Harpoon" },
    { "<leader>fa", desc = "Add file" },
    { "<leader>fr", desc = "Remove file" },
    { "<leader>fo", desc = "Toggle quick menu" },
    { "<leader>fn", desc = "Navigate to next file" },
    { "<leader>fp", desc = "Navigate to previous file" },
    { "<leader>fs", desc = "Select menu item" },
})
