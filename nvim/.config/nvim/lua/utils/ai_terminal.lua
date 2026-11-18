local terminals = {
  "claudecode.terminal",
  "codex.terminal",
}

local M = {}

function M.loaded()
  local loaded = {}
  for _, module_name in ipairs(terminals) do
    local terminal = package.loaded[module_name]
    if terminal then
      table.insert(loaded, terminal)
    end
  end
  return loaded
end

return M
