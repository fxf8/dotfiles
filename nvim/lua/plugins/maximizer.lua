return {
    "szw/vim-maximizer",
    config = function()
        local wk = require("which-key")

        local command = "MaximizerToggle"

        vim.keymap.set("n", "<leader>z", function() vim.cmd(command) end, {})

        wk.add({ { "<leader>z", desc = "Maximizer Toggle" } })
    end
}
