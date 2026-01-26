return {
  "nvim-neo-tree/neo-tree.nvim",
  lazy = false,
  opts = {
    sort_function = function(a, b)
      -- Handle nil names
      if a.name == nil then return false end
      if b.name == nil then return true end

      -- Directories first
      local a_is_dir = a.type == "directory"
      local b_is_dir = b.type == "directory"

      if a_is_dir and not b_is_dir then
        return true
      elseif b_is_dir and not a_is_dir then
        return false
      end

      -- Within same type, prioritize items starting with _
      local a_starts_underscore = a.name:sub(1, 1) == "_"
      local b_starts_underscore = b.name:sub(1, 1) == "_"

      if a_starts_underscore and not b_starts_underscore then
        return true
      elseif b_starts_underscore and not a_starts_underscore then
        return false
      end

      -- Default: sort alphabetically (case-insensitive)
      return a.name:lower() < b.name:lower()
    end,
    filesystem = {
      bind_to_cwd = false,
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
