return {
  "aaronik/treewalker.nvim",
  keys = {
    { "<C-A-j>", "<cmd>Treewalker Down<cr>", desc = "Move down in the syntax tree" },
    { "<C-A-k>", "<cmd>Treewalker Up<cr>", desc = "Move up in the syntax tree" },
    { "<C-A-h>", "<cmd>Treewalker Left<cr>", desc = "Move left in the syntax tree" },
    { "<C-A-l>", "<cmd>Treewalker Right<cr>", desc = "Move right in the syntax tree" },
  },
  opts = {
    highlight = true, -- Whether to briefly highlight the node after jumping to it
    highlight_duration = 250, -- How long should above highlight last (in ms)
  },
}
