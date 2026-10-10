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

        local function strip_cr()
            vim.schedule(function()
                local buf = vim.api.nvim_get_current_buf()
                local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
                local new_lines = {}
                local modified = false
                for _, line in ipairs(lines) do
                    local cleaned = line:gsub('\r', '')
                    table.insert(new_lines, cleaned)
                    if cleaned ~= line then modified = true end
                end
                if modified then
                    vim.api.nvim_buf_set_lines(buf, 0, -1, false, new_lines)
                end
            end)
        end

        local function accepting(fn)
            return function()
                local result = fn()
                strip_cr()
                return result
            end
        end

        vim.keymap.set('i', '<M-j>', accepting(codeium_virtual_text.accept), opts)
        vim.keymap.set('i', '<M-k>', codeium_virtual_text.debounced_complete, opts)
        vim.keymap.set('i', '<M-x>', codeium_virtual_text.clear, opts)
        vim.keymap.set('i', '<M-e>', accepting(codeium_virtual_text.accept_next_word), opts)
        vim.keymap.set('i', '<M-l>', accepting(codeium_virtual_text.accept_next_line), opts)
        vim.keymap.set('i', '<M-h>', function() codeium_virtual_text.cycle_completions(1) end, opts)
        vim.keymap.set('i', '<M-y>', function() codeium_virtual_text.cycle_completions(-1) end, opts)

        require('codeium.virtual_text').set_statusbar_refresh(function()
            require('lualine').refresh()
        end)

        -- vim.cmd("let g:codeium_no_map_tab = 1")
    end
}
