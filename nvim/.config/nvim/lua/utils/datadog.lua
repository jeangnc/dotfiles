local M = {}
local common = require("utils.common")

-- ============================================================================
-- Datadog Metrics Search
-- ============================================================================

function M.search_metrics()
  local result, err = common.execute_popen_command("zsh -ic 'ddmm'")
  if not result then
    vim.notify(err, vim.log.levels.ERROR)
    return
  end

  local lines = common.split_lines(result)

  local fzf_opts = {
    empty_message = "No metrics found",
    fallback_fn = function()
      vim.notify("No results found", vim.log.levels.WARN)
    end
  }

  common.fzf_select(lines, "DD Metrics> ", function(selected_metric)
    local fzf = require("fzf-lua")
    fzf.live_grep({
      search = selected_metric,
      cwd = "app/",
    })
  end, fzf_opts)
end

return M