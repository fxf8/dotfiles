return {
    "tpope/vim-fugitive",
    config = function()
        local wk = require("which-key")

        vim.keymap.set("n", "<leader>go", vim.cmd.Git)
        vim.keymap.set("n", "<leader>gs", function() vim.cmd("Gdiffsplit") end, {})

        local function diffput_visual_selection()
            local start_line, end_line = vim.fn.line("'<"), vim.fn.line("'>")
            local min = math.min(start_line, end_line)
            local max = math.max(start_line, end_line)

            vim.cmd(string.format("%d,%ddiffput", min, max))
        end

        vim.keymap.set("v", "<leader>gp", diffput_visual_selection, {})

        wk.add({
            { "<leader>g", group = "Git Fugitive" },
            { "<leader>go", desc = "Open" },
            { "<leader>gs", desc = "Stage" },
            { "<leader>gp", desc = "Put" },
        })
    end
}
