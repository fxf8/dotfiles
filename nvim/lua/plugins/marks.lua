return {
    "chentoast/marks.nvim",
    event = "VeryLazy",
    opts = {},
    config = function()
        local marks = require("marks")

        local mappings = {
            set_next = "<leader>m,",
            toggle = "<leader>m;",
            delete_line = "<leader>mdl",
            delete_buf = "<leader>mdb",
            next = "<leader>mn",
            prev = "<leader>mp",
            preview = "<leader>m:",
            set = "<leader>mk", -- "Make" the mark
            delete = "<leader>mdd",
            annotate = "<leader>ma",
        }


        marks.setup({
            default_mappings = false,
            mappings = mappings,
        })

        vim.keymap.set("n", "<leader>mt", function() vim.cmd("MarksToggleSigns") end, {})
        vim.keymap.set("n", "<leader>ml", function() vim.cmd("MarksListAll") end, {})

        local wk = require("which-key")
    end
}
