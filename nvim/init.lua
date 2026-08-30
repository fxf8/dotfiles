require("config.lazy")

--[[
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.stories.svelte",
  callback = function(args)
    vim.bo[args.buf].filetype = "svelte"
    -- Force the treesitter engine to attach to the svelte language
    vim.treesitter.start(args.buf, "svelte")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
    callback = function()
        local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
        if lang then
            pcall(vim.treesitter.start)
        end
    end,
})
]]

-- 1. Ensure the filename pattern maps to the svelte filetype
vim.filetype.add({
    pattern = {
        ['.*%.stories%.svelte'] = 'svelte',
    },
    extension = {
        -- Jinja2 templates: use the underlying extension's filetype
        -- (e.g. base.tex.j2 -> tex), falling back to jinja for bare .j2
        j2 = function(path, _)
            local stripped = path:gsub('%.j2$', '')
            local ft = vim.filetype.match({ filename = stripped })
            return ft or 'jinja'
        end,
    },
})

-- 2. Single Autocmd to handle both filetype setting and Treesitter attachment
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = "svelte",
    callback = function(args)
        -- Use pcall (protected call) to start Treesitter. 
        -- This prevents errors if a buffer doesn't have a valid file path.
        pcall(function()
            vim.treesitter.start(args.buf, "svelte")
        end)
    end,
})

require("fuexfollets.set")

if vim.g.neovide then
    vim.o.guifont = "Jetbrains Mono Semibold:12"
end
