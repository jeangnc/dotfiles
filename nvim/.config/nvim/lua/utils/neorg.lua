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

-- ============================================================================
-- File and Content Search
-- ============================================================================

function M.open_file_explorer(directory_path)
  if not directory_path then
    return
  end
  require("neo-tree.command").execute({
    action = "focus",
    source = "filesystem",
    position = "left",
    dir = vim.fn.expand(directory_path),
  })
end

function M.search_files_in_directory(directory_path)
  if not directory_path then
    return
  end
  require("fzf-lua").files({
    prompt = "Neorg » ",
    fd_opts = "--ignore --no-hidden --type=f --extension=norg",
    cwd = directory_path,
  })
end

function M.search_content_in_directory(directory_path)
  if not directory_path then
    return
  end
  require("fzf-lua").live_grep({
    prompt = "Neorg » ",
    fd_opts = "--ignore --no-hidden --type=f",
    cwd = directory_path,
  })
end

-- ============================================================================
-- Note Creation
-- ============================================================================

local function get_available_templates()
  local templates_directory = vim.fn.expand("~/.orgfiles/templates/")
  local template_list = {}
  local template_file_map = {}

  local find_command = "find " .. vim.fn.shellescape(templates_directory) .. " -name '*.norg' -type f 2>/dev/null"
  local handle = io.popen(find_command)

  if handle then
    for template_file_path in handle:lines() do
      local template_name = vim.fn.fnamemodify(template_file_path, ":t:r")
      table.insert(template_list, template_name)
      template_file_map[template_name] = template_file_path
    end
    handle:close()
  end

  return template_list, template_file_map, templates_directory
end

local function create_note_file(filename, template_file_path)
  local workspace_directory = M.current_workspace_dir()
  if not workspace_directory then
    vim.notify("No active neorg workspace", vim.log.levels.ERROR)
    return false
  end

  local normalized_filename = (filename or "new-note"):gsub("%.norg$", "") .. ".norg"
  local full_file_path = workspace_directory .. "/inbox/" .. normalized_filename

  if template_file_path then
    local copy_command =
      string.format("cp %s %s", vim.fn.shellescape(template_file_path), vim.fn.shellescape(full_file_path))

    if vim.fn.system(copy_command) and vim.v.shell_error ~= 0 then
      vim.notify("Failed to copy template: " .. template_file_path, vim.log.levels.ERROR)
      return false
    end
  end

  vim.cmd("edit " .. vim.fn.fnameescape(full_file_path))
  vim.cmd("normal! gg")
  return true
end

function M.create_note_with_template()
  local fzf = require("fzf-lua")
  local template_list, template_file_map, templates_directory = get_available_templates()

  table.insert(template_list, 1, "-- No template --")

  if #template_list == 1 then
    vim.notify("No templates found in " .. templates_directory, vim.log.levels.WARN)
    M.create_blank_note()
    return
  end

  fzf.fzf_exec(template_list, {
    prompt = "Select template> ",
    actions = {
      ["default"] = function(selected_templates)
        if not selected_templates or #selected_templates == 0 then
          return
        end

        local selected_template = selected_templates[1]

        vim.ui.input({ prompt = "Enter filename: " }, function(user_filename)
          if not user_filename or user_filename == "" then
            return
          end

          if selected_template == "-- No template --" then
            M.create_blank_note(user_filename)
          else
            M.create_note_from_template(user_filename, template_file_map[selected_template])
          end
        end)
      end,
    },
  })
end

function M.create_blank_note(filename)
  create_note_file(filename)
end

function M.create_note_from_template(filename, template_file_path)
  create_note_file(filename, template_file_path)
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
  with_workspace_dir(function(workspace_dir)
    M.open_file_explorer(workspace_dir)
  end)
end

function M.search_files()
  with_workspace_dir(function(workspace_dir)
    M.search_files_in_directory(workspace_dir)
  end)
end

function M.search_content()
  with_workspace_dir(function(workspace_dir)
    M.search_content_in_directory(workspace_dir)
  end)
end

function M.explore_journal()
  with_workspace_dir(function(workspace_dir)
    local journal_path = workspace_dir .. "/.journalfiles"
    M.open_file_explorer(journal_path)
  end)
end

return M
