return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    -- See Commands section for default commands if you want to lazy load on them
    config = function(_, opts)
      require("CopilotChat").setup(vim.tbl_deep_extend("force", opts, {
        window = {
          layout = "vertical",
          width = 0.375,
        },
      }))

      local chat = require("CopilotChat")
      vim.keymap.set("n", "<leader>cc", "", {
        callback = chat.toggle,
        desc = "Toggle Copilot",
        noremap = true,
        silent = true,
      })

      vim.keymap.set("v", "<leader>ce", function()
        vim.cmd("CopilotChatExplain")
      end, {
        desc = "Explain selected code with Copilot",
        noremap = true,
        silent = true,
      })
    end,
  },
}
