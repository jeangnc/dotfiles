local M = {}

function M.load_json_file(file_path)
  local stat = vim.uv.fs_stat(file_path)
  if not stat then
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

function M.find_file_in_parents(filename)
  local current_dir = vim.fn.getcwd()

  while current_dir and current_dir ~= "/" do
    local file_path = current_dir .. "/" .. filename
    local stat = vim.uv.fs_stat(file_path)

    if stat then
      return file_path
    end

    current_dir = vim.fn.fnamemodify(current_dir, ":h")
  end

  return nil
end

function M.find_files_by_pattern(directory, pattern, opts)
  opts = opts or {}
  local file_list = {}
  local file_map = {}

  local find_command = "find " .. vim.fn.shellescape(directory) .. " -name '" .. pattern .. "' -type f 2>/dev/null"
  local handle = io.popen(find_command)

  if handle then
    for file_path in handle:lines() do
      local name = opts.name_transformer and opts.name_transformer(file_path) or vim.fn.fnamemodify(file_path, ":t:r")
      table.insert(file_list, name)
      file_map[name] = file_path
    end
    handle:close()
  end

  return file_list, file_map
end

function M.copy_file(source_path, destination_path)
  local copy_command = string.format("cp %s %s", vim.fn.shellescape(source_path), vim.fn.shellescape(destination_path))

  if vim.fn.system(copy_command) and vim.v.shell_error ~= 0 then
    return false, "Failed to copy file: " .. source_path
  end

  return true
end

function M.ensure_directory_exists(directory_path)
  local stat = vim.uv.fs_stat(directory_path)
  if not stat then
    local mkdir_command = "mkdir -p " .. vim.fn.shellescape(directory_path)
    if vim.fn.system(mkdir_command) and vim.v.shell_error ~= 0 then
      return false, "Failed to create directory: " .. directory_path
    end
  end
  return true
end

function M.open_file_and_goto_top(file_path)
  vim.cmd("edit " .. vim.fn.fnameescape(file_path))
  vim.cmd("normal! gg")
end

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

function M.search_files_in_directory(directory_path, opts)
  if not directory_path then
    return
  end

  opts = opts or {}
  local prompt = opts.prompt or "Files » "
  local fd_opts = opts.fd_opts or "--ignore --no-hidden --type=f"

  require("fzf-lua").files({
    prompt = prompt,
    fd_opts = fd_opts,
    cwd = directory_path,
  })
end

function M.search_content_in_directory(directory_path, opts)
  if not directory_path then
    return
  end

  opts = opts or {}
  local prompt = opts.prompt or "Content » "
  local fd_opts = opts.fd_opts or "--ignore --no-hidden --type=f"

  require("fzf-lua").live_grep({
    prompt = prompt,
    fd_opts = fd_opts,
    cwd = directory_path,
  })
end

return M
