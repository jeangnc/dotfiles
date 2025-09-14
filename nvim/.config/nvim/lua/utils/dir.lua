local M = {}
local common = require("utils.common")

-- ============================================================================
-- Path & Directory Utilities
-- ============================================================================

function M.get_stat(path)
  return vim.uv.fs_stat(path)
end

function M.path_exists(path)
  local stat = M.get_stat(path)
  return stat ~= nil
end

function M.is_directory(path)
  local stat = M.get_stat(path)
  return stat ~= nil and stat.type == "directory"
end

function M.is_file(path)
  local stat = M.get_stat(path)
  return stat ~= nil and stat.type == "file"
end

function M.exists(directory_path)
  return M.is_directory(directory_path)
end

function M.validate(directory_path, action_name)
  return common.validate_path(directory_path, action_name or "directory operation")
end

function M.ensure_exists(directory_path)
  if not M.exists(directory_path) then
    local mkdir_command = "mkdir -p " .. vim.fn.shellescape(directory_path)
    local success, err = common.execute_sync_command(mkdir_command)
    if not success then
      return false, "Failed to create directory: " .. directory_path
    end
  end
  return true
end

-- ============================================================================
-- Directory Operations
-- ============================================================================

function M.open_explorer(directory_path)
  if not M.validate(directory_path, "file explorer") then
    return
  end
  require("neo-tree.command").execute({
    action = "focus",
    source = "filesystem",
    position = "left",
    dir = vim.fn.expand(directory_path),
  })
end

function M.search_files(directory_path, opts)
  if not M.validate(directory_path, "file search") then
    return
  end

  local default_opts = {
    prompt = "Files » ",
    fd_opts = "--ignore --no-hidden --type=f"
  }
  opts = common.merge_opts(default_opts, opts)

  require("fzf-lua").files({
    prompt = opts.prompt,
    fd_opts = opts.fd_opts,
    cwd = directory_path,
  })
end

function M.search_content(directory_path, opts)
  if not M.validate(directory_path, "content search") then
    return
  end

  local default_opts = {
    prompt = "Content » ",
    fd_opts = "--ignore --no-hidden --type=f"
  }
  opts = common.merge_opts(default_opts, opts)

  require("fzf-lua").live_grep({
    prompt = opts.prompt,
    fd_opts = opts.fd_opts,
    cwd = directory_path,
  })
end

function M.find_files_by_pattern(directory, pattern, opts)
  opts = opts or {}
  local file_list = {}
  local file_map = {}

  local find_command = "find " .. vim.fn.shellescape(directory) .. " -name '" .. pattern .. "' -type f 2>/dev/null"
  local result, err = common.execute_popen_command(find_command)

  if not result then
    return file_list, file_map
  end

  local file_utils = require("utils.file")
  for file_path in result:gmatch("[^\r\n]+") do
    if file_path ~= "" then
      local name = opts.name_transformer and opts.name_transformer(file_path) or file_utils.get_basename(file_path)
      table.insert(file_list, name)
      file_map[name] = file_path
    end
  end

  return file_list, file_map
end

return M