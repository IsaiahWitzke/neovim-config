return {
  "folke/persistence.nvim",
  lazy = false, -- load immediately to save/restore sessions
  opts = {
    dir = vim.fn.stdpath("state") .. "/sessions/",
    need = 1, -- minimum number of buffers to save
  },
  keys = {
    { "<leader>qs", function() require("persistence").load() end, desc = "Restore session for cwd" },
    { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
    { "<leader>qd", function() require("persistence").stop() end, desc = "Don't save session on exit" },
  },
  config = function(_, opts)
    require("persistence").setup(opts)
    -- Auto-restore session when opening nvim without file arguments
    vim.api.nvim_create_autocmd("VimEnter", {
      group = vim.api.nvim_create_augroup("restore_session", { clear = true }),
      callback = function()
        if vim.fn.argc() == 0 and not vim.g.started_with_stdin then
          -- Delay to run after other VimEnter autocmds (like Neo-tree)
          vim.schedule(function()
            require("persistence").load()
          end)
        end
      end,
      nested = true,
    })
  end,
}
