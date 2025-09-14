local M = {}

function M.get_available_templates(templates_directory, opts)
  templates_directory = templates_directory or vim.fn.expand("~/.orgfiles/templates/")
  opts = opts or {}
  local extension = opts.extension or "*"
  local pattern = "*." .. extension

  local filesystem = require("utils.filesystem")
  local template_list, template_file_map = filesystem.find_files_by_pattern(templates_directory, pattern)

  return template_list, template_file_map, templates_directory
end

function M.create_file_from_template(filename, template_file_path, destination_directory, opts)
  if not filename or not destination_directory then
    return false
  end

  opts = opts or {}
  local extension = opts.extension or "norg"
  local pattern = "%." .. extension .. "$"
  local normalized_filename = filename:gsub(pattern, "") .. "." .. extension
  local full_file_path = destination_directory .. "/" .. normalized_filename

  local filesystem = require("utils.filesystem")

  -- Ensure destination directory exists
  local success, err = filesystem.ensure_directory_exists(destination_directory)
  if not success then
    vim.notify(err, vim.log.levels.ERROR)
    return false
  end

  -- Copy template file if provided
  if template_file_path then
    local success, err = filesystem.copy_file(template_file_path, full_file_path)
    if not success then
      vim.notify(err, vim.log.levels.ERROR)
      return false
    end
  end

  filesystem.open_file_and_goto_top(full_file_path)
  return true
end

function M.select_template_and_create_file(templates_directory, destination_directory, opts)
  if not destination_directory then
    vim.notify("No destination directory provided", vim.log.levels.ERROR)
    return false
  end

  opts = opts or {}
  local fzf = require("fzf-lua")
  local template_list, template_file_map, templates_dir = M.get_available_templates(templates_directory, opts)

  table.insert(template_list, 1, "-- No template --")

  if #template_list == 1 then
    vim.notify("No templates found in " .. templates_dir, vim.log.levels.WARN)
    if opts.fallback_fn then
      opts.fallback_fn()
    end
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
            M.create_file_from_template(user_filename, nil, destination_directory, opts)
          else
            M.create_file_from_template(
              user_filename,
              template_file_map[selected_template],
              destination_directory,
              opts
            )
          end
        end)
      end,
    },
  })
end

return M

