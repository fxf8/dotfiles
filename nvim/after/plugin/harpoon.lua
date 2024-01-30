local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set('n', "<leader>fa", mark.add_file)
vim.keymap.set('n', "<leader>fr", mark.rm_file)
vim.keymap.set('n', "<leader>fo", ui.toggle_quick_menu)

vim.keymap.set('n', "<leader>fn", ui.nav_next)
vim.keymap.set('n', "<leader>fp", ui.nav_prev)
vim.keymap.set('n', "<leader>fs", ui.select_menu_item)
