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

return M

