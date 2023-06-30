vim.keymap.set("n", "<leader>do", function() vim.cmd("Gdiffsplit") end, {})
vim.keymap.set("v", "<leader>dp", function() vim.cmd("diffput") end, {})
