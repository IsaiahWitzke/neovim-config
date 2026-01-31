return {
  "milanglacier/minuet-ai.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("minuet").setup({
      provider = "claude",
      provider_options = {
        claude = {
          max_tokens = 512,
          model = "claude-sonnet-4-20250514",
          api_key = "WARP_DEV_ANTHROPIC_API_KEY", -- env var name
          stream = true,
        },
      },
      -- Virtual text (ghost text like Copilot)
      virtualtext = {
        auto_trigger_ft = { "*" }, -- auto-trigger for all filetypes
        keymap = {
          accept = "<C-y>",      -- accept whole completion
          accept_line = "<C-l>", -- accept one line
          next = "<C-n>",        -- next suggestion
          prev = "<C-p>",        -- prev suggestion
          dismiss = "<C-e>",     -- dismiss
        },
      },
    })
  end,
}
