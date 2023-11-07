vim.keymap.set("n", "<leader>go", vim.cmd.Git)
vim.keymap.set("n", "<leader>do", function() vim.cmd("Gdiffsplit") end, {})

local function diffput_visual_selection()
    local start_line, end_line = vim.fn.line("'<"), vim.fn.line("'>")
    local min = math.min(start_line, end_line)
    local max = math.max(start_line, end_line)

    vim.cmd(string.format("%d,%ddiffput", min, max))
end

vim.keymap.set("v", "<leader>dp", diffput_visual_selection, {})
