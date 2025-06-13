return {
    "Exafunction/windsurf.nvim",
    config = function()
        local codeium = require("codeium")

        codeium.setup({
            virtual_text = {
                enabled = true,
                -- Set to true if you never want completions to be shown automatically.
                manual = false,
                -- How long to wait (in ms) before requesting completions after typing stops.
                idle_delay = 75,

            }
        })

        local codeium_virtual_text = require("codeium.virtual_text")
        local opts = { expr = true }

        vim.keymap.set('i', '<M-j>', codeium_virtual_text.accept, opts)
        vim.keymap.set('i', '<M-k>', codeium_virtual_text.debounced_complete, opts)
        vim.keymap.set('i', '<M-x>', codeium_virtual_text.clear, opts)
        vim.keymap.set('i', '<M-w>', codeium_virtual_text.accept_next_word, opts)
        vim.keymap.set('i', '<M-l>', codeium_virtual_text.accept_next_line, opts)
        vim.keymap.set('i', '<M-h>', function() codeium_virtual_text.cycle_completions(1) end, opts)
        vim.keymap.set('i', '<M-y>', function() codeium_virtual_text.cycle_completions(-1) end, opts)

        codeium_virtual_text.set_statusbar_refresh(function(args)
            print(args)
        end)

        require('codeium.virtual_text').set_statusbar_refresh(function()
            require('lualine').refresh() -- redraw the statusline
        end)

        --[[
    local accept = vim.fn['codeium#Accept']
    local cycle1 = function() vim.fn['codeium#CycleCompletions'](1) end
    local cycle2 = function() vim.fn['codeium#CycleCompletions'](-1) end
    local clear = vim.fn['codeium#Clear']
    local accept_word = vim.fn['codeium#AcceptNextWord']
    local accept_line = vim.fn['codeium#AcceptNextLine']


    vim.keymap.set('i', '<M-j>', accept, opts)
    vim.keymap.set('i', '<M-h>', cycle1, opts)
    vim.keymap.set('i', '<M-k>', cycle2, opts)
    vim.keymap.set('i', '<M-x>', clear, opts)
    vim.keymap.set('i', '<M-w>', accept_word, opts)
    vim.keymap.set('i', '<M-l>', accept_line, opts)
    ]] --

        vim.cmd("let g:codeium_no_map_tab = 1")
    end
}
