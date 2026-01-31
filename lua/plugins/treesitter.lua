return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  main = "nvim-treesitter",
  opts = {
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html", "go", "rust" },
    sync_install = false,
    highlight = { enable = true },
    indent = { enable = true },
  },
}
