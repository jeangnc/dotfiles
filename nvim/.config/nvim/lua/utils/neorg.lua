local M = {}

-- ============================================================================
-- Workspace Management
-- ============================================================================

function M.current_workspace_dir()
  local dirman = require("neorg").modules.get_module("core.dirman")
  local current_workspace = dirman.get_current_workspace()

  if current_workspace then
    return tostring(current_workspace[2])
  end
end

function M.is_file_in_workspace(file_path)
  local workspace_dir = M.current_workspace_dir()
  if not workspace_dir then
    return false
  end
  return file_path:find(workspace_dir, 1, true) == 1
end

function M.get_default_workspace()
  local filesystem = require("utils.filesystem")
  local config_path = filesystem.find_file_in_parents(".neorg/config.json")

  if config_path then
    local config = filesystem.load_json_file(config_path)
    if config and config.default_workspace then
      return config.default_workspace
    end
  end

  return "work"
end

-- ============================================================================
-- Neorg-specific UI Functions
-- ============================================================================

function M.search_files_in_directory(directory_path)
  local filesystem = require("utils.filesystem")
  return filesystem.search_files_in_directory(directory_path, {
    prompt = "Neorg » ",
    fd_opts = "--ignore --no-hidden --type=f --extension=norg",
  })
end

function M.search_content_in_directory(directory_path)
  local filesystem = require("utils.filesystem")
  return filesystem.search_content_in_directory(directory_path, {
    prompt = "Neorg » ",
    fd_opts = "--ignore --no-hidden --type=f",
  })
end

-- ============================================================================
-- Note Creation
-- ============================================================================

function M.create_note_with_template()
  local workspace_directory = M.current_workspace_dir()
  if not workspace_directory then
    vim.notify("No active neorg workspace", vim.log.levels.ERROR)
    return false
  end

  local templates = require("utils.templates")
  local templates_directory = vim.fn.expand("~/.orgfiles/templates/")
  local destination_directory = workspace_directory .. "/inbox"

  return templates.select_template_and_create_file(templates_directory, destination_directory, {
    extension = "norg",
    fallback_fn = function()
      M.create_blank_note()
    end,
  })
end

function M.create_blank_note(filename)
  local workspace_directory = M.current_workspace_dir()
  if not workspace_directory then
    vim.notify("No active neorg workspace", vim.log.levels.ERROR)
    return false
  end

  local templates = require("utils.templates")
  local destination_directory = workspace_directory .. "/inbox"
  return templates.create_file_from_template(filename or "new-note", nil, destination_directory, {
    extension = "norg"
  })
end

function M.create_note_from_template(filename, template_file_path)
  local workspace_directory = M.current_workspace_dir()
  if not workspace_directory then
    vim.notify("No active neorg workspace", vim.log.levels.ERROR)
    return false
  end

  local templates = require("utils.templates")
  local destination_directory = workspace_directory .. "/inbox"
  return templates.create_file_from_template(filename, template_file_path, destination_directory, {
    extension = "norg"
  })
end

-- ============================================================================
-- Convenience Functions (Workspace Shortcuts)
-- ============================================================================

local function with_workspace_dir(callback)
  local workspace_dir = M.current_workspace_dir()
  if not workspace_dir then
    vim.notify("No active neorg workspace found", vim.log.levels.ERROR)
    return false
  end
  callback(workspace_dir)
  return true
end

function M.explore_workspace()
  local filesystem = require("utils.filesystem")
  return with_workspace_dir(filesystem.open_file_explorer)
end

function M.search_files()
  return with_workspace_dir(M.search_files_in_directory)
end

function M.search_content()
  return with_workspace_dir(M.search_content_in_directory)
end

function M.explore_journal()
  local filesystem = require("utils.filesystem")
  return with_workspace_dir(function(workspace_dir)
    filesystem.open_file_explorer(workspace_dir .. "/.journalfiles")
  end)
end

return M

