return {
    "mbbill/undotree",
    config = function()
        local wk = require("which-key")
        vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)

        -- vimscript

        vim.cmd [[
        if has("persistent_undo")
            let target_path = expand('~/.undodir')

            " create the directory and any parent directories
            " if the location does not exist.
            if !isdirectory(target_path)
                call mkdir(target_path, "p", 0700)
            endif

            let &undodir=target_path
            set undofile
        endif
        ]]

        wk.add({
            { "<leader>u", desc = "Toggle undo tree" },
        })
    end
}
