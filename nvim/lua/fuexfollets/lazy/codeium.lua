return {
    "Exafunction/codeium.vim",
    config = function()
        local accept = vim.fn['codeium#Accept']
        local cycle1 = function() vim.fn['codeium#CycleCompletions'](1) end
        local cycle2 = function() vim.fn['codeium#CycleCompletions'](-1) end
        local clear = vim.fn['codeium#Clear']
        local accept_word = vim.fn['codeium#AcceptNextWord']
        local accept_line = vim.fn['codeium#AcceptNextLine']

        local opts = { expr = true }

        vim.keymap.set('i', '<M-j>', accept, opts)
        vim.keymap.set('i', '<M-h>', cycle1, opts)
        vim.keymap.set('i', '<M-k>', cycle2, opts)
        vim.keymap.set('i', '<M-x>', clear, opts)
        vim.keymap.set('i', '<M-w>', accept_word, opts)
        vim.keymap.set('i', '<M-l>', accept_line, opts)
    end
}
