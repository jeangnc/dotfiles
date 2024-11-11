return {
  "nvim-neo-tree/neo-tree.nvim",
  lazy = false,
  opts = {
    filesystem = {
      bind_to_cwd = true,
      hijack_netrw_behavior = "open_current",
    },
    event_handlers = {
      {
        event = "file_open_requested",
        handler = function()
          require("neo-tree.command").execute({ action = "close" })
        end,
      },
    },
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
}
