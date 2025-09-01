local M = {}

function M.current_workspace_dir()
  local dirman = require("neorg").modules.get_module("core.dirman")
  local current_workspace = dirman.get_current_workspace()

  if current_workspace then
    return tostring(current_workspace[2])
  end
end

function M.neotree_explore(folder)
  if not folder then
    return
  end

  local expanded_path = vim.fn.expand(folder)

  require("neo-tree.command").execute({
    action = "focus",
    source = "filesystem",
    position = "left",
    dir = expanded_path,
  })
end

function M.fzf_grep(folder)
  if not folder then
    return
  end

  local opts = {
    prompt = "Neorg » ",
    fd_opts = "--ignore --no-hidden --type=f",
    cwd = folder,
  }

  require("fzf-lua").live_grep(opts)
end

function M.get_default_workspace()
  local utils = require("utils")
  local config_path = utils.find_file_in_parents(".neorg/config.json")

  if config_path then
    local config = utils.load_json_file(config_path)
    if config and config.default_workspace then
      return config.default_workspace
    end
  end

  return "work"
end

return M