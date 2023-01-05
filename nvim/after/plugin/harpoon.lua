local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

vim.keymap.set('n', "<leader>a", mark.add_file)
vim.keymap.set('n', "<leader><C-e>", ui.toggle_quick_menu)

vim.keymap.set('n', "<leader><C-n>", ui.nav_next)
vim.keymap.set('n', "<leader><C-b>", ui.nav_prev)
