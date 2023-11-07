local builtin = require('telescope.builtin')

vim.keymap.set('n', "<leader>pf", builtin.find_files, {}) -- For general files
vim.keymap.set('n', "<leader>pg", builtin.git_files, {}) -- For current git directory
vim.keymap.set('n', "<leader>ps", builtin.live_grep, {}) -- Grep file search

vim.api.nvim_create_autocmd({ "BufEnter" }, { pattern = { "*" }, command = "normal zx", })
