return { {
    "theprimeagen/harpoon",
    -- branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local wk = require("which-key")
        local harpoon_mark = require("harpoon.mark")
        local harpoon_ui = require("harpoon.ui")

        vim.keymap.set('n', "<leader>ha", harpoon_mark.add_file)
        vim.keymap.set('n', "<leader>hr", harpoon_mark.rm_file)
        vim.keymap.set('n', "<leader>ho", harpoon_ui.toggle_quick_menu)

        vim.keymap.set('n', "<leader>hn", harpoon_ui.nav_next)
        vim.keymap.set('n', "<leader>hp", harpoon_ui.nav_prev)
        vim.keymap.set('n', "<leader>hs", harpoon_ui.select_menu_item)

        --[[
        local harpoon = require("harpoon")

        harpoon:setup()

        vim.keymap.set('n', "<leader>ha", function() harpoon:list():add() end)
        vim.keymap.set('n', "<leader>ho", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
        -- vim.keymap.set('n', "<leader>hr", mark.rm_file)

        vim.keymap.set('n', "<leader>hn", function() harpoon:list():prev() end)
        vim.keymap.set('n', "<leader>hp", function() harpoon:list():next() end)
        -- vim.keymap.set('n', "<leader>hs", ui.select_menu_item)
        ]]

        wk.add({
            { "<leader>h",  group = "Harpoon" },
            { "<leader>ha", desc = "Add file" },
            { "<leader>hr", desc = "Remove file" },
            { "<leader>ho", desc = "Toggle quick menu" },
            { "<leader>hn", desc = "Navigate to next file" },
            { "<leader>hp", desc = "Navigate to previous file" },
            { "<leader>hs", desc = "Select menu item" },
        })
    end
},

    --[[
    ---@type LazySpec
    {
        "mikavilpas/yazi.nvim",
        version = "*", -- use the latest stable version
        event = "VeryLazy",
        dependencies = {
            { "nvim-lua/plenary.nvim", lazy = true },
        },
        keys = {
            -- 👇 in this section, choose your own keymappings!
            {
                "<leader>-",
                mode = { "n", "v" },
                "<cmd>Yazi<cr>",
                desc = "Open yazi at the current file",
            },
            {
                -- Open in the current working directory
                "<leader>cw",
                "<cmd>Yazi cwd<cr>",
                desc = "Open the file manager in nvim's working directory",
            },
            {
                "<c-up>",
                "<cmd>Yazi toggle<cr>",
                desc = "Resume the last yazi session",
            },
        },
        ---@type YaziConfig | {}
        opts = {
            -- if you want to open yazi instead of netrw, see below for more info
            open_for_directories = false,
            keymaps = {
                show_help = "<f1>",
            },
        },
        -- 👇 if you use `open_for_directories=true`, this is recommended
        init = function()
            -- mark netrw as loaded so it's not loaded at all.
            --
            -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
            vim.g.loaded_netrwPlugin = 1
        end,

        config = function()
            local yazi = require("yazi")
            local harpoon_mark = require("harpoon.mark")


            vim.keymap.set("n", "<leader>ha", function()
                -- Check if yazi is currently open and active
                local yazi_buffer = vim.bo.filetype == "yazi"

                if yazi_buffer then
                    -- Get the hovered file/directory path from Yazi's internal state
                    local hovered_path = require("yazi.state").get_current_hovered_file()

                    if hovered_path then
                        -- Harpoon expects paths relative to the project root
                        local relative_path = vim.fn.fnamemodify(hovered_path, ":.")

                        -- Add it to Harpoon
                        harpoon_mark.add_file_to_list(relative_path)
                        print("Added to Harpoon: " .. relative_path)
                    end
                else
                    -- Fallback to standard Harpoon behavior if Yazi isn't open
                    harpoon_mark.add_file()
                end
            end, { desc = "Harpoon: Add current file or Yazi selection" })
        end
    }]] }
