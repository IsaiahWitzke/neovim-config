return {
  "mason-org/mason-lspconfig.nvim",
  dependancies = {
    "mason-org/mason.nvim",
  },
  lazy = false,
  opts = {
    ensure_installed = { "lua_ls", "pyright", "ts_ls" },
  },
  config = true,
}
