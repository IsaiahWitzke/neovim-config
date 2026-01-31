-- split right...
vim.opt.splitright = true

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

-- Suppress deprecation warnings (lspconfig migration to vim.lsp.config)
vim.deprecate = function() end

-- Auto-reload files changed externally
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

require("config.lazy")

vim.keymap.set("n", "<leader>e", "<Cmd>Neotree reveal<CR>")
vim.keymap.set("n", "<leader>E", "<Cmd>Neotree toggle<CR>")
vim.cmd("colorscheme vim")

local lspconfig = require('lspconfig')

-- Configure pyright
-- lspconfig.pyright.setup{}

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
--
-- vim.keymap.set("n", "<leader>ts", [[<C-w>s <C-w>j <cmd>terminal<CR>]])

-- open terminal in a split window, if one already exists, switch focus to it
-- if currently in terminal, switch back to the previous window
local previous_win = nil

vim.keymap.set('n', '<C-`>', function()
  local term_bufnr = nil
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype == 'terminal' then
      term_bufnr = buf
      if vim.api.nvim_get_current_win() == win then
        -- If already in terminal, switch back to the previous window
        if previous_win and vim.api.nvim_win_is_valid(previous_win) then
          vim.api.nvim_set_current_win(previous_win)
        end
        return
      else
        -- Save the current window before switching to the terminal
        previous_win = vim.api.nvim_get_current_win()
        vim.api.nvim_set_current_win(win)
        return
      end
    end
  end

  -- If no terminal is found, open one and save the current window
  if not term_bufnr then
    previous_win = vim.api.nvim_get_current_win()
    vim.cmd('botright split | resize 15% | terminal')
    vim.cmd('startinsert')
  end
end, { noremap = true, silent = true })


-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#e3d4d3", fg = "#4a394a" })
vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })

