local M = {}

function M.search_metrics()
  local fzf = require("fzf-lua")

  local handle = io.popen("zsh -ic 'ddmm'")
  local result = handle:read("*a")
  handle:close()

  local lines = {}
  for line in result:gmatch("[^\r\n]+") do
    if line ~= "" then
      table.insert(lines, line)
    end
  end

  if #lines == 0 then
    table.insert(lines, "No results found")
  end

  fzf.fzf_exec(lines, {
    prompt = "DD Metrics> ",
    actions = {
      ["default"] = function(selected)
        if selected and selected[1] then
          fzf.live_grep({
            search = selected[1],
            cwd = "app/",
          })
        end
      end,
    },
  })
end

return M

