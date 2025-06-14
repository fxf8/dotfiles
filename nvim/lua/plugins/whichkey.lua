return {
    "folke/which-key.nvim",
    config = function()
        local wk = require("which-key")

        wk.add({
            { "<leader>w", desc = "Write" },
            { "<leader>W", desc = "Write all" },
            { "<leader>q", desc = "Quit" },
            { "<leader>Q", desc = "Quit without saving" },
            { "<leader>e", desc = "Quit all" },
            { "<leader>E", desc = "Quit all without saving" },
            { "<leader>A", desc = "Write and quit all" },
            { "<leader>F", desc = "Open netrw" },
            { "<leader>s", desc = "Split based on current window size" },
        })
    end
}
