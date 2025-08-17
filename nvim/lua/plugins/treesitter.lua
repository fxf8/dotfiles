return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" }, -- Lazy-load on buffer read/new
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "bash",
                    "c",
                    "cpp",
                    "rust",
                    "html",
                    "javascript",
                    "typescript",
                    "json",
                    "lua",
                    "markdown",
                    "python",
                    "typescript",
                    "vim",
                    "yaml",
                    "toml",
                },
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = { enable = true },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<C-space>",
                        node_incremental = "<C-space>",
                        node_decremental = "<bs>",
                    },
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                        },
                    },
                },
            })
        end,
    },
    -- Optional dependencies for extended functionality
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        lazy = true,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = { "nvim-treesitter/nvim-treesitter", "folke/which-key.nvim" },
        opts = {
            enable = true,
            mode = "cursor",
            line_numbers = true,
        },
        config = function()
            local wk = require("which-key")

            vim.keymap.set("n", "<leader>ko", function() vim.cmd("TSContext enable") end)
            vim.keymap.set("n", "<leader>kp", function() vim.cmd("TSContext disable") end)
            vim.keymap.set("n", "<leader>kt", function() vim.cmd("TSContext toggle") end)

            wk.add({
                { "<leader>k",  group = "Treesitter context" },
                { "<leader>ko", desc = "Context open" },
                { "<leader>kp", desc = "Context close" },
                { "<leader>kt", desc = "Context toggle" },
            })

            vim.cmd("TSContext disable")
        end,
    },
}

--[[
config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash",
          "c",
          "html",
          "javascript",
          "json",
          "lua",
          "markdown",
          "python",
          "typescript",
          "vim",
          "yaml",
        },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            node_decremental = "<bs>",
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
        },
      })
    end,
  },
  -- Optional dependencies for extended functionality
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    lazy = true,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = {
      enable = true,
      mode = "topline",
      line_numbers = true,
    },
  },
]]
