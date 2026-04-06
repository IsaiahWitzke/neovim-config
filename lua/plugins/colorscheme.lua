return {
  "projekt0n/github-nvim-theme",
  lazy = false,
  priority = 1000, -- load before other plugins
  config = function()
    require("github-theme").setup({})
    vim.cmd("colorscheme github_light")
  end,
}
