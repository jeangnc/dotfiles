return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      default_component_configs = {
        indent = {
          padding = 0, -- Reduz o espaço ao redor dos ícones
        },
        git_status = {
          symbols = {
            unstaged = "",
            staged = "",
          },
        },
      },
    },
  },
}
