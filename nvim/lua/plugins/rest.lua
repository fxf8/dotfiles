return {
    "rest-nvim/rest.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            table.insert(opts.ensure_installed, "http")
        end,
    },
    config = function()
        local wk = require("which-key")

        vim.keymap.set('n', '<leader>rr', function() vim.cmd('Rest run') end, { desc = 'Rest run request' })
        vim.keymap.set('n', '<leader>rc', function() vim.cmd('Rest curl') end, { desc = 'Preview curl' })
        vim.keymap.set('n', '<leader>ro', function() vim.cmd('Rest open') end, { desc = 'Repeat last request' })

        wk.add({
            { "<leader>r",  group = "Rest" },
            { "<leader>rr", desc = "Rest run " },
            { "<leader>rc", desc = "Preview curl" },
            { "<leader>ro", desc = "Repeat last request" },
        })
    end
}
