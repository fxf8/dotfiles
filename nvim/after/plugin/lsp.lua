local lsp = require('lsp-zero')

local lsp_lines = require('lsp_lines')

lsp.preset('recommended') -- Default presets

lsp.set_preferences({
    suggest_lsp_servers = true,
    setup_servers_on_start = true,
    set_lsp_keymaps = true,
    configure_diagnostics = true,
    cmp_capabilities = true,
    manage_nvim_cmp = true,
    call_servers = 'local',
    sign_icons = {
        error = '✘',
        warn = '▲',
        hint = '⚑',
        info = ''
    }
})

vim.opt.signcolumn = 'yes'

lsp.on_attach(function(client, bufnr)
    local options = {buffer = bufnr, remap = false}

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, options)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, options)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, options)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, options)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, options)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, options)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, options)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, options)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, options)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, options)
end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = true,
    virtual_lines = false -- { only_current_line = true }
})

-- vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)

-- Disable virtual_text since it's redundant due to lsp_lines.
-- vim.diagnostic.config({
--  virtual_text = false,
-- })

-- lsp_lines.setup()

-- vim.diagnostic.config({ virtual_lines = true })

