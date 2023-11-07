vim.keymap.set("n", "<leader>go", vim.cmd.Git)
vim.keymap.set("n", "<leader>do", function() vim.cmd("Gdiffsplit") end, {})

local function diffput_visual_selection()
    local start_line, end_line = vim.fn.line("'<"), vim.fn.line("'>")

    vim.cmd(string.format("%d,%ddiffput", start_line, end_line))
end

vim.keymap.set("v", "<leader>dp", diffput_visual_selection, {})
