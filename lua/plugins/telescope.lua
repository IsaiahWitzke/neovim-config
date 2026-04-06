return {
  'nvim-telescope/telescope.nvim', branch = 'master',
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
    vim.keymap.set('n', '<leader>fG', function()
      local file_type = vim.fn.input('File type (leave blank for all): ')
      local exclude_tests = vim.fn.input('Exclude *_test files? (y/n, default n): ')
      local args = {}
      if file_type ~= '' then
        table.insert(args, '--type')
        table.insert(args, file_type)
      end
      if exclude_tests:lower() == 'y' then
        table.insert(args, '--glob')
        table.insert(args, '!*_test.*')
      end
      builtin.live_grep({ additional_args = args })
    end, { desc = 'Telescope live grep with filters' })
    vim.keymap.set('n', '<leader>fs', function()
      builtin.live_grep({ additional_args = { '--fixed-strings' } })
    end, { desc = 'Telescope fixed string search' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
    vim.keymap.set('n', '<leader>fc', builtin.colorscheme, { desc = 'Telescope colorschemes' })
    vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = 'Telescope keymaps' })
  end,
}
