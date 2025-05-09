-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.number = true
vim.opt.relativenumber = false

-- Enable syntax highlighting (enabled by default in Lua, but good to know)
vim.cmd('syntax on')

-- Enable mouse mode
vim.opt.mouse = 'a'

-- Set tab settings
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Enable true color support
vim.opt.termguicolors = true

-- Use system clipboard
vim.opt.clipboard = 'unnamedplus'

vim.cmd('colorscheme vim')

require("config.lazy")

vim.keymap.set("n", "<leader>e", "<Cmd>Neotree reveal<CR>")

