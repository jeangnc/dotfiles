return {
  "greggh/claude-code.nvim",
  keys = {
    { "<leader>ac", "<cmd>ClaudeCode<CR>", desc = "Toggle Claude Code" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim", -- Required for git operations
  },
  config = function()
    require("claude-code").setup({
      window = {
        split_ratio = 0.5,
        position = "vertical", -- Position of the window: "botright", "topleft", "vertical", "float", etc.
      },
    })
  end,
}
