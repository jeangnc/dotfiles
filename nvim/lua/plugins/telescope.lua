return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "angkeith/telescope-terraform-doc.nvim",
  },
  opts = function(_, opts)
    local actions = require("telescope.actions")

    opts.defaults = {
      file_ignore_patterns = {
        ".git",
        "node_modules",
        "build",
        "dist",
        "yarn.lock",
      },
      mappings = {
        i = {
          ["<C-j>"] = require("telescope.actions").move_selection_next,
          ["<C-k>"] = require("telescope.actions").move_selection_previous,
          ["<Esc>"] = actions.close,
          -- fixes fold issue on neorg
          ["<CR>"] = function()
            vim.cmd([[:stopinsert]])
            vim.cmd([[call feedkeys("\<CR>")]])
          end,
        },
      },
    }
  end,
}
