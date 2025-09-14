local M = {}
local common = require("utils.common")
local file = require("utils.file")
local dir = require("utils.dir")

-- ============================================================================
-- Template Discovery
-- ============================================================================

function M.get_available_templates(templates_directory, opts)
  local default_opts = { extension = "*" }
  opts = common.merge_opts(default_opts, opts)

  templates_directory = templates_directory or vim.fn.expand("~/.orgfiles/templates/")
  local pattern = "*." .. opts.extension

  local template_list, template_file_map = dir.find_files_by_pattern(templates_directory, pattern)
  return template_list, template_file_map, templates_directory
end

-- ============================================================================
-- File Creation
-- ============================================================================

function M.create_file_from_template(filename, template_file_path, destination_directory, opts)
  if not common.validate_path(filename, "filename") or not common.validate_path(destination_directory, "destination directory") then
    return false
  end

  local default_opts = { extension = "norg" }
  opts = common.merge_opts(default_opts, opts)

  local normalized_filename = file.normalize_filename(filename, opts.extension)
  local full_file_path = file.join_paths(destination_directory, normalized_filename)

  -- Ensure destination directory exists
  local success, err = dir.ensure_exists(destination_directory)
  if not common.handle_result(success, err) then
    return false
  end

  -- Copy template file if provided
  if template_file_path then
    local success, err = file.copy(template_file_path, full_file_path)
    if not common.handle_result(success, err) then
      return false
    end
  end

  file.open_and_goto_top(full_file_path)
  return true
end

-- ============================================================================
-- Interactive Template Selection
-- ============================================================================

function M.select_template_and_create_file(templates_directory, destination_directory, opts)
  if not common.validate_path(destination_directory, "destination directory") then
    return false
  end

  opts = opts or {}
  local template_list, template_file_map, templates_dir = M.get_available_templates(templates_directory, opts)

  table.insert(template_list, 1, "-- No template --")

  local fzf_opts = {
    empty_message = "No templates found in " .. templates_dir,
    fallback_fn = opts.fallback_fn
  }

  common.fzf_select(template_list, "Select template> ", function(selected_template)
    common.fzf_input("Enter filename: ", function(user_filename)
      local template_file_path = selected_template == "-- No template --"
        and nil
        or template_file_map[selected_template]

      M.create_file_from_template(user_filename, template_file_path, destination_directory, opts)
    end)
  end, fzf_opts)
end

return M