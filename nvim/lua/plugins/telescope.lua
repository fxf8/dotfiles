return {
    "nvim-telescope/telescope.nvim",
    depends = { "nvim-lua/plenary.nvim" },
    config = function()
        local wk = require("which-key")
        local builtin = require('telescope.builtin')

        vim.keymap.set('n', "<leader>pf", builtin.find_files, {}) -- For general files
        vim.keymap.set('n', "<leader>pg", builtin.git_files, {})  -- For current git directory
        vim.keymap.set('n', "<leader>ps", builtin.live_grep, {})  -- Grep file search

        wk.add({
            { "<leader>p",  group = "Telescope (file search)" },
            { "<leader>pf", desc = "Find files" },
            { "<leader>pg", desc = "Git files" },
            { "<leader>ps", desc = "Live grep" },
        })

        -- vim.api.nvim_create_autocmd({ "BufEnter" }, { pattern = { "*" }, command = "normal zx", })
    end
}
