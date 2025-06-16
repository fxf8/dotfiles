local wk = require("which-key")
local toggleterm = require('toggleterm')

toggleterm.setup({
    size = function(term)
        if term.direction == 'horizontal' then
            return 20
        elseif term.direction == 'vertical' then
            return vim.o.columns * 0.4
        end
    end,

    insert_mappings = false,
    shell = "fish",

    winbar = {
        enabled = false,
        name_formatter = function(term) --  term: Terminal
            return term.name
        end
    },
})

vim.keymap.set("n", "<leader>to",
    function()
        -- toggleterm.toggle(count size dir direction name)
        local direction = vim.o.lines * 2 > vim.o.columns and 'horizontal' or 'vertical'
        local size = direction == 'vertical' and vim.o.columns * 0.4 or 20
        local directory = vim.fn.expand('%:p:h')
        toggleterm.toggle(nil, size, directory, direction, directory)
    end,
    {}
)

vim.keymap.set("n", "<leader>ti",
    function()
        -- toggleterm.toggle(count size dir direction name)
        local direction = vim.o.lines * 2 > vim.o.columns and 'horizontal' or 'vertical'
        local size = direction == 'vertical' and vim.o.columns * 0.4 or 20
        local directory = vim.fn.finddir(".git", ".;")
        directory = vim.fn.fnamemodify(directory, ":h")
        toggleterm.toggle(nil, size, directory, direction, directory)
    end,
    {}
)


wk.add({
    { "<leader>t",  group = "Terminal" },
    { "<leader>to", desc = "Toggle terminal" },
    { "<leader>ti", desc = "Toggle terminal in git directory" },
})
