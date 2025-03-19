local Path = require("plenary.path")

local function configure_copilot()
    local opts = { noremap = true, silent = true, expr = true, replace_keycodes = false }

    vim.keymap.set('i', '<M-j>', 'copilot#Accept()', opts)
    vim.keymap.set('i', '<M-p>', 'copilot#Previous()', opts)
    vim.keymap.set('i', '<M-n>', 'copilot#Next()', opts)
    vim.keymap.set('i', '<M-l>', 'copilot#AcceptLine()', opts)
    vim.keymap.set('i', '<M-w>', 'copilot#AcceptWord()', opts)
    vim.keymap.set('i', '<M-d>', 'copilot#Dismiss()', opts)
    vim.keymap.set('i', '<M-s>', 'copilot#Suggest()', opts)

    vim.keymap.set('n', '<leader>co',
        function()
            vim.cmd('Copilot panel')
        end,
        {}
    )
end

local function configure_codeium()
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

    vim.cmd("let g:codeium_no_map_tab = 1")
end


USE_AI_SETTING_PATH = vim.fn.stdpath("data") .. "/use_ai_setting_path.json"

local function set_key(key, value)
    local settings = {}
    settings[key] = value
    Path:new(USE_AI_SETTING_PATH):write(vim.fn.json_encode(settings), "w")
end

local function get_key(key)
    -- also read from the file
    local settings = vim.fn.json_decode(Path:new(USE_AI_SETTING_PATH):read())
    return settings[key]
end

if not Path:new(USE_AI_SETTING_PATH):exists() then
    set_key("ai", "codeium")
    set_key("disabled_ai", "copilot")
end

local function use_copilot()
    if get_key("ai") == "codeium" then
        set_key("ai", "copilot")
        vim.cmd("Copilot enable")
    end

    if get_key("disabled_ai") == "copilot" then
        set_key("disabled_ai", "codeium")
        vim.cmd("CodeiumDisable")
    end
end

local function use_codeium()
    if get_key("ai") == "copilot" then
        set_key("ai", "codeium")
        vim.cmd("CodeiumEnable")
    end

    if get_key("disabled_ai") == "codeium" then
        set_key("disabled_ai", "copilot")
        vim.cmd("Copilot disable")
    end
end

-- if the table says to use copilot, then use copilot, otherwise use codeium. Read from the file

local function use_ai()
    local settings = vim.fn.json_decode(Path:new(USE_AI_SETTING_PATH):read())
    if settings["ai"] == "copilot" then
        use_copilot()
        configure_copilot()
    else
        use_codeium()
        configure_codeium()
    end
end

-- Create a command to switch between copilot and codeium. Call it 'SwapAI'

local function swap_ai()
    local settings = vim.fn.json_decode(Path:new(USE_AI_SETTING_PATH):read())
    if settings["ai"] == "copilot" then
        use_codeium()
        configure_codeium()
    else
        use_copilot()
        configure_copilot()
    end
end

local function current_ai()
    local settings = vim.fn.json_decode(Path:new(USE_AI_SETTING_PATH):read())
    if settings["ai"] == "copilot" then
        print("Current AI: Copilot")
    else
        print("Current AI: Codeium")
    end
end

vim.api.nvim_create_user_command("AISwap", swap_ai, {})
vim.api.nvim_create_user_command("AICurrent", current_ai, {})

use_ai()
