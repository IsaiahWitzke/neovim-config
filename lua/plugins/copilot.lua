return {
  {
    'github/copilot.vim',
    config = function()
      -- Any additional Vimscript or Lua setup can be done here
      -- For example, you can map keys or adjust settings
      vim.cmd([[
        let g:copilot_no_tab_map = v:true
        imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
      ]])
    end,
  }
}
