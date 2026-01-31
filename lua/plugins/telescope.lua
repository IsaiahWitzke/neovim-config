return {
  'nvim-telescope/telescope.nvim', branch  = '0.1.x',
--or                              , branch = '0.1.x',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local builtin = require('telescope.builtin')

    vim.keymap.set(
      'n',
      '<leader>ff',
      function()
        builtin.find_files({ hidden = true })
      end,
      { desc = 'Telescope find files' }
    )
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
    vim.keymap.set('n', '<leader>fs', function()
      builtin.live_grep({ additional_args = { '--fixed-strings' } })
    end, { desc = 'Telescope fixed string search' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
  end,
}
