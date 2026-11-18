local state_path = vim.fn.stdpath("state") .. "/ai-agent"

local function stored_agent()
  if vim.fn.filereadable(state_path) == 0 then
    return "claude"
  end

  local ok, lines = pcall(vim.fn.readfile, state_path)
  local name = ok and lines[1]
  return name == "codex" and "codex" or "claude"
end

local name = stored_agent()
vim.g.ai_agent = name

local M = {}

function M.current()
  return name
end

function M.select(next_name)
  if next_name ~= "claude" and next_name ~= "codex" then
    return nil, "Expected 'claude' or 'codex'"
  end
  if next_name == name then
    return true
  end

  local directory = vim.fn.fnamemodify(state_path, ":h")
  if vim.fn.mkdir(directory, "p") == -1 then
    return nil, "Could not create " .. directory
  end

  local temporary_path = state_path .. "." .. vim.fn.getpid()
  local ok, result = pcall(vim.fn.writefile, { next_name }, temporary_path, "s")
  if not ok or result ~= 0 then
    return nil, "Could not write " .. temporary_path .. ": " .. tostring(result)
  end

  local renamed, error_message = (vim.uv or vim.loop).fs_rename(temporary_path, state_path)
  if not renamed then
    (vim.uv or vim.loop).fs_unlink(temporary_path)
    return nil, "Could not save " .. state_path .. ": " .. tostring(error_message)
  end

  name = next_name
  vim.g.ai_agent = name
  return true
end

return M
