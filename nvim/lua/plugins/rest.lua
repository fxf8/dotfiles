return {
    "rest-nvim/rest.nvim",
    config = function()
        local wk = require("which-key")

        vim.keymap.set('n', '<leader>re', '<Plug>RestNvim', { desc = 'Execute request' })
        vim.keymap.set('n', '<leader>rp', '<Plug>RestNvimPreview', { desc = 'Preview curl' })
        vim.keymap.set('n', '<leader>rr', '<Plug>RestNvimLast', { desc = 'Repeat last request' })

        wk.add({
            { "<leader>r",  group = "Rest" },
            { "<leader>re", desc = "Execute request" },
            { "<leader>rp", desc = "Preview curl" },
            { "<leader>rr", desc = "Repeat last request" },
        })
    end
}
