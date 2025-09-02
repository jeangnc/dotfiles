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
  require("neo-tree.command").execute({
    action = "focus",
    source = "filesystem",
    position = "left",
    dir = vim.fn.expand(folder),
  })
end

function M.fzf_grep(folder)
  if not folder then
    return
  end
  require("fzf-lua").live_grep({
    prompt = "Neorg » ",
    fd_opts = "--ignore --no-hidden --type=f",
    cwd = folder,
  })
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

function M.create_note_with_template()
  local fzf = require("fzf-lua")
  local templates_dir = vim.fn.expand("~/.orgfiles/templates/")

  local templates = {}
  local template_files = {}
  local handle = io.popen("find " .. vim.fn.shellescape(templates_dir) .. " -name '*.norg' -type f 2>/dev/null")
  if handle then
    for file in handle:lines() do
      local template_name = vim.fn.fnamemodify(file, ":t:r")
      table.insert(templates, template_name)
      template_files[template_name] = file
    end
    handle:close()
  end

  table.insert(templates, 1, "-- No template --")

  if #templates == 1 then
    vim.notify("No templates found in " .. templates_dir, vim.log.levels.WARN)
    M.create_blank_note()
    return
  end

  fzf.fzf_exec(templates, {
    prompt = "Select template> ",
    actions = {
      ["default"] = function(selected)
        if not selected or #selected == 0 then
          return
        end

        local template = selected[1]

        vim.ui.input({ prompt = "Enter filename: " }, function(filename)
          if not filename or filename == "" then
            return
          end

          if template == "-- No template --" then
            M.create_blank_note(filename)
          else
            M.create_note_from_template(filename, template_files[template])
          end
        end)
      end,
    },
  })
end

local function create_note_file(filename, template_file)
  local workspace_dir = M.current_workspace_dir()
  if not workspace_dir then
    vim.notify("No active neorg workspace", vim.log.levels.ERROR)
    return
  end

  filename = (filename or "new-note"):gsub("%.norg$", "") .. ".norg"
  local filepath = workspace_dir .. "/" .. filename

  if template_file then
    local cmd = string.format("cp %s %s", vim.fn.shellescape(template_file), vim.fn.shellescape(filepath))
    if vim.fn.system(cmd) and vim.v.shell_error ~= 0 then
      vim.notify("Failed to copy template: " .. template_file, vim.log.levels.ERROR)
      return
    end
  end

  vim.cmd("edit " .. vim.fn.fnameescape(filepath))
  vim.cmd("normal! gg")
end

function M.create_blank_note(filename)
  create_note_file(filename)
end

function M.create_note_from_template(filename, template_file)
  create_note_file(filename, template_file)
end

return M

