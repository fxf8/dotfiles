vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 8
vim.opt.cursorline = true

vim.opt.errorbells = false
vim.opt.ignorecase = true
vim.opt.lazyredraw = true
vim.opt.smartindent = true

vim.opt.colorcolumn = "100"


--[[
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.preserveindent = true
vim.opt.expandtab = false
vim.api.nvim_set_keymap("i", "<Tab>", "\t", { noremap = true, silent = true }) -- Tab inserts a tab character
vim.api.nvim_set_keymap("i", "<A-Tab>", "<C-v><Space><C-v><Space><C-v><Space><C-v><Space>",
	{ noremap = true, silent = true })                                         -- Shift+Tab inserts spaces
vim.opt.listchars = {
	-- tab = "│ ", -- tab = "▸ ",     -- Display tabs as '▸ ' (▸ followed by a space)
	--     space = ".",    -- Optional: Show spaces as dots
	trail = "_", -- trail = "·",    -- Optional: Show trailing spaces
	extends = "⟩", -- Optional: Show when text overflows
	precedes = "⟨", -- Optional: Show when there's hidden text to the left
}
]] --

vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "*",
    callback = function()
        vim.opt.tabstop = 4
        vim.opt.softtabstop = 4
        vim.opt.shiftwidth = 4
        vim.opt.preserveindent = true
        vim.opt.expandtab = true
        vim.api.nvim_set_keymap("i", "<Tab>", "\t", { noremap = true, silent = true }) -- Tab inserts a tab character
        --[[
        vim.api.nvim_set_keymap("i", "<A-Tab>", "<C-v><Space><C-v><Space><C-v><Space><C-v><Space>",
            { noremap = true, silent = true })                                         -- Shift+Tab inserts spaces
            ]]

        vim.api.nvim_set_keymap("i", "<A-Tab>", "<C-v><Tab>", { noremap = true, silent = true })

        vim.opt.listchars = {
            tab = "│ ", -- tab = "▏ ", -- tab = "▸ ", -- tab = "│ ", -- tab = "▸ ",     -- Display tabs as '▸ ' (▸ followed by a space)
            --     space = ".",    -- Optional: Show spaces as dots
            trail = "_", -- trail = "·",    -- Optional: Show trailing spaces
            extends = "⟩", -- Optional: Show when text overflows
            precedes = "⟨", -- Optional: Show when there's hidden text to the left
            -- multispace = "·   ",
        }

        --[[
		local indent = vim.fn.indent(vim.fn.line('.')) -- Get current line indent
		if indent % 8 == 0 then
			vim.opt.listchars = { tab = "▏ " } -- Show vertical bar for tabs at certain indents
		else
			vim.opt.listchars = { tab = "  " } -- Otherwise, hide them
		end
		]] --
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "netrw",
    callback = function()
        local opts = { remap = true, buffer = true }

        -- 'H' goes up to the parent directory (maps to netrw's '-' action)
        vim.keymap.set("n", "H", "-", opts)

        -- 'L' opens the file or enters the directory (maps to netrw's '<CR>' action)
        vim.keymap.set("n", "L", "<CR>", opts)
    end,
})

vim.opt.smartindent = true

vim.opt.wrap = true

vim.opt.swapfile = false

vim.g.mapleader = " "

vim.keymap.set("n", "<leader>w", vim.cmd.w)                     -- Write to current file
vim.keymap.set("n", "<leader>W", vim.cmd.wall)                  -- Write to all
vim.keymap.set("n", "<leader>q", vim.cmd.q)                     -- Quit
vim.keymap.set("n", "<leader>Q", function() vim.cmd("q!") end)  -- Quit without saving
vim.keymap.set("n", "<leader>e", vim.cmd.qall)                  -- Quit all 'E'
vim.keymap.set("n", "<leader>E", function() vim.cmd("qa!") end) -- Quit all without saving
-- Write and quit to all 'A"
vim.keymap.set("n", "<leader>A", vim.cmd.wqa)
vim.keymap.set("n", "<leader>F", function() vim.cmd("Explore") end)

vim.keymap.set("n", "<leader>LU", function() vim.cmd("Lazy update") end)

vim.keymap.set({ "n", "v" }, "\\", "%")

-- Scroll down and move cursor down
vim.keymap.set({ 'n', 'v' }, '<C-e>', 'j<C-e>', { noremap = true, silent = true })

-- Scroll up and move cursor up
vim.keymap.set({ 'n', 'v' }, '<C-y>', 'k<C-y>', { noremap = true, silent = true })

-- Enter netrw

-- Split based on current window size
vim.keymap.set("n", "<leader>s", function()
    local width = vim.api.nvim_win_get_width(0)
    local height = vim.api.nvim_win_get_height(0)
    local char_ratio = 135 / 55 -- window width / height

    if width / height > char_ratio then
        vim.cmd.vsplit()
    else
        vim.cmd.split()
    end
end) -- Split

vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("v", "j", "gj")
vim.keymap.set("v", "k", "gk")

vim.keymap.set("n", "-", "`")
vim.keymap.set("v", "-", "`")

local function print_buffer_info()
    -- 1. Get the absolute path of the current buffer
    -- '0' always refers to the current active buffer
    local full_path = vim.api.nvim_buf_get_name(0)

    -- If the buffer hasn't been saved to a file yet, it will be empty
    if full_path == "" then
        print("Buffer has no file path (unsaved or special buffer).")
        return
    end

    -- 2. Use vim.fn.expand for easy string parsing of the path
    local filename = vim.fn.expand("%:t")
    local extension = vim.fn.expand("%:e")
    local parent_dir = vim.fn.expand("%:p:h")

    -- 3. Use Libuv (vim.uv) to get filesystem metadata
    local stats = vim.uv.fs_stat(full_path)

    local size = "Unknown"
    local modified = "Unknown"

    if stats then
        -- Convert bytes to something readable (KB)
        size = string.format("%.2f KB", stats.size / 1024)
        -- Convert timestamp to readable date
        modified = os.date("%Y-%m-%d %H:%M:%S", stats.mtime.sec)
    end

    -- 4. Get Buffer-specific state
    local is_modified = vim.api.nvim_get_option_value("modified", { buf = 0 })
    local filetype = vim.api.nvim_get_option_value("filetype", { buf = 0 })

    -- Print the output
    --[[
    print("--- Buffer Information ---")
    print("Full Path:  " .. full_path)
    print("Directory:  " .. parent_dir)
    print("File Name:  " .. filename)
    print("Extension:  " .. (extension ~= "" and extension or "None"))
    print("Filetype:   " .. filetype)
    print("File Size:  " .. size)
    print("Modified:   " .. (is_modified and "Yes (Unsaved changes)" or "No"))
    print("Last Saved: " .. modified)
    print("--------------------------")
    ]]

    print("Path: " .. full_path .. "    Size: " .. size)
end

-- Map it to a key for quick testing (e.g., <leader>bi for "Buffer Info")
vim.keymap.set('n', '<leader>bi', print_buffer_info, { desc = "Print current buffer info" })
