-- local flutter_tools = require("flutter-tools")

--[[
flutter_tools.setup {
    lsp = {
        on_attach = function(client, bufnr)
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
            vim.keymap.set("n", "<leader>lzf", function() vim.lsp.buf.format() end, options)
            vim.keymap.set("v", "<leader>lzf", function() vim.lsp.buf.format() end, options)
        end,
    },
}
]]
