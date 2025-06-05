local wk = require("which-key")
local Path = require("plenary.path")
local dapui = require("dapui")
local dap = require("dap")
local mason_dap = require("mason-nvim-dap")
local virtual_text = require("nvim-dap-virtual-text")

virtual_text.setup {
    enabled = true,                     -- enable this plugin (the default)
    enabled_commands = true,            -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
    highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
    highlight_new_as_changed = false,   -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
    show_stop_reason = true,            -- show stop reason when stopped for exceptions
    commented = false,                  -- prefix virtual text with comment string
    only_first_definition = true,       -- only show virtual text at first definition (if there are multiple)
    all_references = false,             -- show virtual text on all all references of the variable (not only definitions)
    clear_on_continue = false,          -- clear virtual text on "continue" (might cause flickering when stepping)
    --- A callback that determines how a variable is displayed or whether it should be omitted
    --- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
    --- @param buf number
    --- @param stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
    --- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
    --- @param options nvim_dap_virtual_text_options Current options for nvim-dap-virtual-text
    --- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
    display_callback = function(variable, buf, stackframe, node, options)
        if options.virt_text_pos == 'inline' then
            return ' = ' .. variable.value
        else
            return variable.name .. ' = ' .. variable.value
        end
    end,
    -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
    virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',

    -- experimental features:
    all_frames = false,     -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
    virt_lines = false,     -- show virtual lines instead of virtual text (will flicker!)
    virt_text_win_col = nil -- position the virtual text at a fixed window column (starting from the first text column) ,
    -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
}

mason_dap.setup()

DAP_CACHED_TEST_EXECUTION_TABLE = vim.fn.stdpath("data") .. "/dap_cached_test_execution.json"
DAP_TEST_EXECUTION_TABLE = {} -- (path: string) -> {path: string, args: string[], use_cached: boolean}

if not Path:new(DAP_CACHED_TEST_EXECUTION_TABLE):exists() then
    Path:new(DAP_CACHED_TEST_EXECUTION_TABLE):write(vim.fn.json_encode(DAP_TEST_EXECUTION_TABLE), "w")
end

function DAP_ENABLE_USE_CACHE()
    local cwd = vim.fn.getcwd()
    local file = Path:new(DAP_CACHED_TEST_EXECUTION_TABLE)
    local json_data = vim.fn.json_decode(file:read())

    if json_data == nil then
        json_data = {}
    end

    if json_data[cwd] == nil then
        json_data[cwd] = {
            use_cached = true,
            path = nil,
            args = nil,
        }
    end

    json_data[cwd].use_cached = true

    file:write(vim.fn.json_encode(json_data), "w")

    print(string.format("DAP test execution cache enabled: executable path = %s, args = %s", json_data[cwd].path,
        json_data[cwd].args))
end

function DAP_DISABLE_USE_CACHE()
    local cwd = vim.fn.getcwd()
    local file = Path:new(DAP_CACHED_TEST_EXECUTION_TABLE)
    local json_data = vim.fn.json_decode(file:read())

    if json_data == nil then
        json_data = {}
    end

    if json_data[cwd] == nil then
        json_data[cwd] = {
            use_cached = false,
            path = nil,
            args = nil,
        }
    end

    json_data[cwd].use_cached = false

    file:write(vim.fn.json_encode(json_data), "w")

    print("DAP test execution cache disabled")
end

function DAP_TOGGLE_USE_CACHE()
    local cwd = vim.fn.getcwd()
    local file = Path:new(DAP_CACHED_TEST_EXECUTION_TABLE)
    local json_data = vim.fn.json_decode(file:read())

    if json_data == nil then
        json_data = {}
    end

    if json_data[cwd] == nil then
        json_data[cwd] = {
            use_cached = false,
            path = nil,
            args = nil,
        }
    end

    json_data[cwd].use_cached = not json_data[cwd].use_cached

    file:write(vim.fn.json_encode(json_data), "w")

    print(string.format("DAP test execution cache %s", json_data[cwd].use_cached and "enabled" or "disabled"))
end

-- Rewrite dap.configurations.cpp to use the new cache system

dap.configurations.cpp = {
    {
        name = "Launch",
        type = "lldb",
        request = "launch",
        program = function()
            local cwd = vim.fn.getcwd()
            local file = Path:new(DAP_CACHED_TEST_EXECUTION_TABLE)
            local json_data = vim.fn.json_decode(file:read())

            if json_data == nil then
                json_data = {}
            end

            if json_data[cwd] == nil then
                json_data[cwd] = {
                    use_cached = false,
                    path = nil,
                    args = nil,
                }
            end

            if json_data[cwd].use_cached then
                return json_data[cwd].path
            end

            local res = vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            json_data[cwd].path = res

            file:write(vim.fn.json_encode(json_data), "w")

            return res
        end,
        args = function()
            local cwd = vim.fn.getcwd()
            local file = Path:new(DAP_CACHED_TEST_EXECUTION_TABLE)
            local json_data = vim.fn.json_decode(file:read())

            if json_data == nil then
                json_data = {}
            end

            if json_data[cwd] == nil then
                json_data[cwd] = {
                    use_cached = false,
                    path = nil,
                    args = nil,
                }
            end

            if json_data[cwd].use_cached then
                return json_data[cwd].args
            end

            local args = vim.fn.input('Program arguments: ', '', 'file')
            if args == '' then
                json_data[cwd].args = nil
                file:write(vim.fn.json_encode(json_data), "w")

                return nil
            else
                local res = vim.split(args, ' ', true)

                json_data[cwd].args = res
                file:write(vim.fn.json_encode(json_data), "w")

                return res
            end
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
    },
}

dap.adapters.lldb = {
    type = 'executable',
    command = '/usr/bin/lldb-vscode', -- adjust as needed, must be absolute path
    name = 'lldb'
}

-- This should also work with python poetry

dap.configurations.python = {
    {
        type = 'python',
        request = 'launch',
        name = 'Launch file',
        program = "${file}",
        pythonPath = function()
            local cwd = vim.fn.getcwd()
            local file = Path:new(DAP_CACHED_TEST_EXECUTION_TABLE)
            local json_data = vim.fn.json_decode(file:read())

            if json_data == nil then
                json_data = {}
            end

            if json_data[cwd] == nil then
                json_data[cwd] = {
                    use_cached = false,
                    path = nil,
                    args = nil,
                }
            end

            if json_data[cwd].use_cached then
                return json_data[cwd].path
            end

            local res = vim.fn.input('Path to python interpreter: ', vim.fn.getcwd() .. '/', 'file')
            json_data[cwd].path = res

            file:write(vim.fn.json_encode(json_data), "w")

            return res
        end,
    },
}

dap.adapters.python = {
    type = 'executable',
    command = 'python',
    args = { '-m', 'debugpy.adapter' }
}

dapui.setup()

-- Dap Main 'd'
vim.keymap.set('n', '<leader>dt', dapui.toggle)                                -- Dap toggle
vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint)                       -- Dap toggle breakpoint
vim.keymap.set('n', '<leader>dp', dap.continue)                                -- Dap proceed
vim.keymap.set('n', '<leader>do', function() dapui.open({ reset = true }) end) -- open dapui

-- Dap Movements 'dm'
vim.keymap.set('n', '<leader>dmu', dap.up)        -- Dap move up
vim.keymap.set('n', '<leader>dmd', dap.down)      -- Dap move down
vim.keymap.set('n', '<leader>dmr', dap.restart)   -- Dap restart
vim.keymap.set('n', '<leader>dmo', dap.step_over) -- Dap step over
vim.keymap.set('n', '<leader>dmi', dap.step_into) -- Dap step into

-- Dap Runtime 'dr'
vim.keymap.set('n', '<leader>drp', dap.pause)     -- Dap thread paues
vim.keymap.set('n', '<leader>drc', dap.close)     -- Dap thread close
vim.keymap.set('n', '<leader>dro', dap.repl.open) -- Dap repl open

-- Dap Cache 'dc'
vim.keymap.set('n', '<leader>dce', DAP_ENABLE_USE_CACHE)  -- Dap cache enable
vim.keymap.set('n', '<leader>dcd', DAP_DISABLE_USE_CACHE) -- Dap cache disable
vim.keymap.set('n', '<leader>dct', DAP_TOGGLE_USE_CACHE)  -- Dap cache toggle

-- Dap Virtual Text 'dv'
vim.keymap.set('n', '<leader>dvd', function() vim.cmd("DapVirtualTextDisable") end)      -- Dap virtual text disable
vim.keymap.set('n', '<leader>dve', function() vim.cmd("DapVirtualTextEnable") end)       -- Dap virtual text enable
vim.keymap.set('n', '<leader>dvt', function() vim.cmd("DapVirtualTextToggle") end)       -- Dap virtual text force refresh
vim.keymap.set('n', '<leader>dvf', function() vim.cmd("DapVirtualTextForceRefresh") end) -- Dap virtual text force refresh

wk.add({
    -- Main
    { "<leader>d",   group = "Dap" },
    { "<leader>dt",  desc = "Dap toggle" },
    { "<leader>db",  desc = "Dap toggle breakpoint" },
    { "<leader>dp",  desc = "Dap proceed" },
    { "<leader>do",  desc = "Dap open ui" },
    -- Movement
    { "<leader>dm",  group = "Dap movement" },
    { "<leader>dmu", desc = "Dap move up" },
    { "<leader>dmd", desc = "Dap move down" },
    { "<leader>dmr", desc = "Dap restart" },
    { "<leader>dmo", desc = "Dap step over" },
    { "<leader>dmi", desc = "Dap step into" },
    -- Runtime
    { "<leader>dr",  group = "Dap runtime" },
    { "<leader>drp", desc = "Dap thread paues" },
    { "<leader>drc", desc = "Dap thread close" },
    { "<leader>dro", desc = "Dap repl open" },
    -- Cache
    { "<leader>dc",  group = "Dap cache" },
    { "<leader>dce", desc = "Dap cache enable" },
    { "<leader>dcd", desc = "Dap cache disable" },
    { "<leader>dct", desc = "Dap cache toggle" },
    -- Virtual Text
    { "<leader>dv",  group = "Dap virtual text" },
    { "<leader>dvd", desc = "Dap virtual text disable" },
    { "<leader>dve", desc = "Dap virtual text enable" },
    { "<leader>dvt", desc = "Dap virtual text toggle" },
    { "<leader>dvf", desc = "Dap virtual text force refresh" },
})
