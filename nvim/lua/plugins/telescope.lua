return {
  "nvim-telescope/telescope.nvim",
  opts = {
    defaults = {
      mappings = {
        i = {
          ["<C-j>"] = require("telescope.actions").move_selection_next, -- Move para o próximo item
          ["<C-k>"] = require("telescope.actions").move_selection_previous, -- Move para o item anterior
        },
        n = {
          ["<C-j>"] = require("telescope.actions").move_selection_next, -- Move para o próximo item no modo normal
          ["<C-k>"] = require("telescope.actions").move_selection_previous, -- Move para o item anterior no modo normal
        },
      },
    },
  },
}
