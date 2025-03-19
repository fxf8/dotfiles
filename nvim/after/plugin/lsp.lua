local wk = require('which-key')
local lsp = require('lsp-zero')
local lspconfig = require('lspconfig')
local neodev = require('neodev')
local cmp = require('cmp')
local mason = require('mason')

mason.setup()

local inlay_hints = require('lsp-inlayhints')
inlay_hints.setup()

neodev.setup({})

-- lsp.preset('recommended') -- Default presets

--[[
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
]]

vim.opt.signcolumn = 'yes'

local lspconfig_defaults = require('lspconfig').util.default_config

lspconfig_defaults.capabilities = vim.tbl_deep_extend(
    'force',
    lspconfig_defaults.capabilities,
    require('cmp_nvim_lsp').default_capabilities()
)

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local options = { buffer = event.buf }

        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, options)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, options)
        vim.keymap.set("n", "<leader>ls", function() vim.lsp.buf.workspace_symbol() end, options)
        vim.keymap.set("n", "<leader>ld", function() vim.diagnostic.open_float() end, options)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, options)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, options)
        vim.keymap.set("n", "<leader>la", function() vim.lsp.buf.code_action() end, options)
        vim.keymap.set("n", "<leader>lr", function() vim.lsp.buf.references() end, options)
        vim.keymap.set("n", "<leader>ln", function() vim.lsp.buf.rename() end, options)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, options)
        vim.keymap.set("n", "<leader>lf", function() vim.lsp.buf.format() end, options)
        vim.keymap.set("v", "<leader>lf", function() vim.lsp.buf.format() end, options)

        wk.add({
            { "<leader>l",  group = "LSP Actions" },
            { "<leader>ls", desc = "Workspace symbol" },
            { "<leader>ld", desc = "Open diagnostics" },
            { "[d",         desc = "Next diagnostic" },
            { "]d",         desc = "Previous diagnostic" },
            { "<leader>la", desc = "Code actions" },
            { "<leader>lr", desc = "Find references" },
            { "<leader>ln", desc = "Rename symbol" },
            { "<C-h>",      desc = "Signature help" },
            { "<leader>lf", desc = "Format code" },
        })
    end,
})

lspconfig.lua_ls.setup({})

lspconfig.clangd.setup({
    cmd = { 'clangd', '--background-index', '--clang-tidy',
        '--header-insertion=iwyu', '--completion-style=detailed' },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'h', 'hpp', 'm', 'mm', 'cc', 'hh', 'cxx', 'hxx' },
    on_attach = inlay_hints.on_attach,
    init_options = {
        clangdFileStatus = true,
        usePlaceholders = true,
        completeUnimported = true,
        semanticHighlighting = true,
        -- clangd will automatically find a compile_commands.json file in parent directories
        -- root_dir = lspconfig.util.root_pattern('compile_commands.json', 'compile_flags.txt', '.git')
    },
    root_dir = lspconfig.util.root_pattern('compile_commands.json', 'compile_flags.txt', '.git')
})

lspconfig.rust_analyzer.setup({
    on_attach = inlay_hints.on_attach,
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_dir = lspconfig.util.root_pattern("Cargo.toml", ".git"),
    settings = { documentSymbol = true },
    capabilities = lsp.capabilities
})

lsp.configure('gopls', {
    on_attach = lsp.on_attach,
    capabilities = lsp.capabilities,
    cmd = { 'gopls' },
    filetypes = { 'go', 'gomod', "gowork", "gotmpl" },
    root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
})

lspconfig.ruff.setup {}
lspconfig.basedpyright.setup {}
-- lspconfig.pyright.setup {}
lspconfig.html.setup {}
lspconfig.jsonls.setup {}

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

cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
    },
    snippet = {
        expand = function(args)
            -- You need Neovim v0.10 to use vim.snippet
            vim.snippet.expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({}),
})

local expand_macro = function()
    vim.lsp.buf_request_all(0, "rust-analyzer/expandMacro",
        vim.lsp.util.make_position_params(),
        function(result)
            -- Create a new tab
            vim.cmd("vsplit")

            -- Create an empty scratch buffer (non-listed, non-file i.e scratch)
            -- :help nvim_create_buf
            local buf = vim.api.nvim_create_buf(false, true)

            -- and set it to the current window
            -- :help nvim_win_set_buf
            vim.api.nvim_win_set_buf(0, buf)

            if result then
                -- set the filetype to rust so that rust's syntax highlighting works
                -- :help nvim_set_option_value
                vim.api.nvim_set_option_value("filetype", "rust", { buf = 0 })

                -- Insert the result into the new buffer
                for client_id, res in pairs(result) do
                    if res and res.result and res.result.expansion then
                        -- :help nvim_buf_set_lines
                        vim.api.nvim_buf_set_lines(buf, -1, -1, false, vim.split(res.result.expansion, "\n"))
                    else
                        vim.api.nvim_buf_set_lines(buf, -1, -1, false, {
                            "No expansion available."
                        })
                    end
                end
            else
                vim.api.nvim_buf_set_lines(buf, -1, -1, false, {
                    "Error: No result returned."
                })
            end
        end)
end

vim.api.nvim_create_user_command('ExpandMacro', expand_macro, {})
