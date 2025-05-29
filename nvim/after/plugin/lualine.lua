local lualine = require('lualine')
local codeium_virtual_text = require("codeium.virtual_text")

local function codeium_status()
    return codeium_virtual_text.status_string()
end

lualine.setup({
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = {
            'filename',
            {
                codeium_status,   -- our custom Codeium status component
                cond = function() -- optional: only show when in insert/normal
                    return vim.fn.mode():match('[in]') ~= nil
                end,
                padding = { left = 1, right = 1 },
            },
        },
        lualine_x = { 'encoding', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location', 'searchcount', 'selectioncount' },
    }
});
