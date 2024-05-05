local lsp = require('lsp-zero').preset({})
local lspconfig = require('lspconfig')
local neodev = require('neodev')
local inlay_hints = require('lsp-inlayhints')

neodev.setup({})

-- lsp.preset('recommended') -- Default presets
lsp.set_preferences({
    call_servers = 'local',
    cmp_capabilities = true,
    configure_diagnostics = true,
    manage_nvim_cmp = true,
    set_lsp_keymaps = true,
    setup_servers_on_start = true,
    suggest_lsp_servers = true,
    sign_icons = {
        error = '✘',
        warn = '▲',
        hint = '⚑',
        info = ''
    }
})

lsp.on_attach(function(client, bufnr)
    local options = { buffer = bufnr, remap = false }

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
    vim.keymap.set("n", "<leader>lzf", function() vim.lsp.buf.format() end, options)
    vim.keymap.set("v", "<leader>lzf", function() vim.lsp.buf.format() end, options)
end)

inlay_hints.setup()

lsp.configure('cmake', {
    root_dir = lspconfig.util.root_pattern('CMakeLists.txt')
})

lspconfig.clangd.setup({
    cmd = { 'clangd', '--background-index', '--clang-tidy',
        '--header-insertion=iwyu', '--completion-style=detailed' },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'h', 'hpp', 'm', 'mm', 'cc', 'hh', 'cxx', 'hxx' },
    on_attach = inlay_hints.on_attach,
    --[[
    init_options = {
        clangdFileStatus = true,
        usePlaceholders = true,
        completeUnimported = true,
        semanticHighlighting = true,
        -- clangd will automatically find a compile_commands.json file in parent directories
        -- root_dir = lspconfig.util.root_pattern('compile_commands.json', 'compile_flags.txt', '.git')
    },
    on_attach = lsp.on_attach,
    root_dir = lspconfig.util.root_pattern('compile_commands.json', 'compile_flags.txt', '.git')
    ]] --
})

lsp.configure('gopls', {
    on_attach = lsp.on_attach,
    capabilities = lsp.capabilities,
    cmd = { 'gopls' },
    filetypes = { 'go', 'gomod', "gowork", "gotmpl" },
    root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
})

lsp.setup()

vim.opt.signcolumn = 'yes'

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = true,
    virtual_lines = false -- { only_current_line = true }
})
