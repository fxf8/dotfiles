return {
    "nvim-telescope/telescope.nvim",
    depends = { "nvim-lua/plenary.nvim" },
    config = function()
        local wk = require("which-key")
        local builtin = require('telescope.builtin')

        vim.keymap.set('n', "<leader>ff", builtin.find_files, {}) -- For general files
        vim.keymap.set('n', "<leader>fg", builtin.git_files, {})  -- For current git directory
        vim.keymap.set('n', "<leader>fs", builtin.live_grep, {})  -- Grep file search

        wk.add({
            { "<leader>f",  group = "Telescope (file search)" },
            { "<leader>ff", desc = "Find files" },
            { "<leader>fg", desc = "Git files" },
            { "<leader>fs", desc = "Live grep" },
        })

        -- vim.api.nvim_create_autocmd({ "BufEnter" }, { pattern = { "*" }, command = "normal zx", })
    end
}
