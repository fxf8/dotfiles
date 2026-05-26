require("config.lazy")

vim.treesitter.language.register('svelte', 'svelte')

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.stories.svelte",
    callback = function(args)
        -- 1. Ensure the filetype is strictly 'svelte'
        vim.bo[args.buf].filetype = "svelte"

        -- 2. Force Treesitter to restart for this specific buffer
        -- We use a scheduled function to ensure the buffer is fully loaded
        vim.schedule(function()
            if vim.api.nvim_buf_is_valid(args.buf) then
                vim.treesitter.stop(args.buf)
                vim.treesitter.start(args.buf, 'svelte')
            end
        end)
    end,
})

require("fuexfollets.set")

if vim.g.neovide then
    vim.o.guifont = "Jetbrains Mono Semibold:12"
end
