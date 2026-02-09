return {
  {
    "stevearc/aerial.nvim",
    keys = {
      { "<localleader><tab>", "<cmd>AerialToggle<cr>", desc = "Toggle Outline/ToC" },
    },
    opts = {
      -- Priority list of preferred backends for aerial.
      -- This can be a filetype map (see :help aerial-filetype-map)
      backends = { "treesitter", "lsp", "markdown", "asciidoc", "man" },
      layout = {
        min_width = 0.3,
        default_direction = "left",
      },

      -- Jump to symbol in source window when the cursor moves
      autojump = true,

      -- Use symbol tree for folding. Set to true or false to enable/disable
      -- Set to "auto" to manage folds if your previous foldmethod was 'manual'
      -- This can be a filetype map (see :help aerial-filetype-map)
      -- manage_folds = true,

      -- When you fold code with za, zo, or zc, update the aerial tree as well.
      -- Only works when manage_folds = true
      -- link_folds_to_tree = true,
    },
  },
}
