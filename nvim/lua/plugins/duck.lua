return {
    'tamton-aquib/duck.nvim',
    dependencies = { 'folke/which-key.nvim' },
    config = function()
        local duck = require("duck")

        vim.keymap.set('n', '<leader>Dd', function() duck.hatch() end, {})
        vim.keymap.set('n', '<leader>Dk', function() duck.cook() end, {})
        vim.keymap.set('n', '<leader>Da', function() duck.cook_all() end, {})

        local wk = require('which-key')
        wk.add({
            { "<leader>D",  group = "Duck Actions" },
            { "<leader>Dd", desc = "Hatch duck" },
            { "<leader>Dk", desc = "Cook duck" },
            { "<leader>Da", desc = "Cook all ducks" },
        })
    end
}
