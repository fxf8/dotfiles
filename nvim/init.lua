require("config.lazy")

--[[
local function fix_rose_pine_ts()
    local links = {
        ["@punctuation.bracket"] = "Delimiter",
        ["@punctuation.delimiter"] = "Delimiter",
        ["@operator"] = "Operator",
        ["@keyword.operator"] = "Operator",
        ["@punctuation.special"] = "Delimiter",
    }
    for new_group, old_group in pairs(links) do
        vim.api.nvim_set_hl(0, new_group, { link = old_group, default = true })
    end
end

-- Run it now and on every colorscheme change
fix_rose_pine_ts()
vim.api.nvim_create_autocmd("ColorScheme", { callback = fix_rose_pine_ts })
]]

vim.api.nvim_create_autocmd("FileType", {
    callback = function()
        local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
        if lang then
            pcall(vim.treesitter.start)
        end
    end,
})

-- require("fuexfollets.packer")
require("fuexfollets.set")
-- require("fuexfollets.treesitter")

if vim.g.neovide then
    vim.o.guifont = "Jetbrains Mono Semibold:12"
end
