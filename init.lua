-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.opt.number = true
vim.opt.relativenumber = false

-- Enable syntax highlighting (enabled by default in Lua, but good to know)
vim.cmd("syntax on")

-- Enable mouse mode
vim.opt.mouse = "a"

-- Set tab settings
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Enable true color support
vim.opt.termguicolors = true

-- Use system clipboard
vim.opt.clipboard = "unnamedplus"

require("config.lazy")

vim.keymap.set("n", "<leader>e", "<Cmd>Neotree reveal<CR>")
vim.cmd("colorscheme vim")

local lspconfig = require('lspconfig')

-- Configure pyright
lspconfig.pyright.setup{}

-- Optional: Add keybindings for code actions
local on_attach = function(client, bufnr)
  local opts = { noremap=true, silent=true }

  -- Keybinding for code actions (e.g., <leader>ca)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  -- or using telescope
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>Telescope lsp_code_actions<CR>', opts)
end

-- Initialize pyright with on_attach
lspconfig.pyright.setup{
  on_attach = on_attach
}

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])
vim.keymap.set("n", "<leader>ts", [[<C-w>s <C-w>j <cmd>terminal<CR>]])

vim.keymap.set("n", "<leader>ct", function()
  local chat = require("CopilotChat")
  chat.toggle()
end, { desc = "Toggle Copilot" })

-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#e3d4d3", fg = "#4a394a" })
vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })


