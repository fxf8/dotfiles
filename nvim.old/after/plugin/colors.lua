vim.g.tokyonight_transparent_sidebar = true
vim.g.tokyonight_transparent = true
vim.opt.background = "dark"

vim.cmd("syntax enable")
vim.cmd("colorscheme tokyonight-night")
vim.cmd("set list")

-- vim.cmd("hi Normal guibg=NONE ctermbg=NONE") -- for transparent background

-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

vim.cmd("TransparentEnable")
