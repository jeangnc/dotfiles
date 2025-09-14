local M = {}
local common = require("utils.common")

-- ============================================================================
-- File System Helper Functions
-- ============================================================================

function M.exists(file_path)
  local dir = require("utils.dir")
  return dir.is_file(file_path)
end

-- ============================================================================
-- Path Utilities
-- ============================================================================

function M.get_directory(file_path)
  return vim.fn.fnamemodify(file_path, ":h")
end

function M.get_filename(file_path)
  return vim.fn.fnamemodify(file_path, ":t")
end

function M.get_basename(file_path)
  return vim.fn.fnamemodify(file_path, ":t:r")
end

function M.join_paths(...)
  local paths = {...}
  return table.concat(paths, "/")
end

function M.normalize_filename(filename, extension)
  extension = extension or "txt"
  local pattern = "%." .. extension .. "$"
  return filename:gsub(pattern, "") .. "." .. extension
end

-- ============================================================================
-- File Operations
-- ============================================================================

function M.load_json(file_path)
  if not M.exists(file_path) then
    return nil
  end

  local file = io.open(file_path, "r")
  if not file then
    return nil
  end

  local content = file:read("*a")
  file:close()

  local ok, config = pcall(vim.json.decode, content)
  if not ok then
    return nil
  end

  return config
end

function M.find_in_parents(filename)
  local current_dir = vim.fn.getcwd()
  local dir = require("utils.dir")

  while current_dir and current_dir ~= "/" do
    local file_path = M.join_paths(current_dir, filename)
    if dir.path_exists(file_path) then
      return file_path
    end
    current_dir = vim.fn.fnamemodify(current_dir, ":h")
  end

  return nil
end

function M.copy(source_path, destination_path)
  local copy_command = string.format("cp %s %s",
    vim.fn.shellescape(source_path),
    vim.fn.shellescape(destination_path))

  local success, err = common.execute_sync_command(copy_command)
  if not success then
    return false, "Failed to copy file: " .. source_path
  end
  return true
end

function M.open_and_goto_top(file_path)
  vim.cmd("edit " .. vim.fn.fnameescape(file_path))
  vim.cmd("normal! gg")
end


return M