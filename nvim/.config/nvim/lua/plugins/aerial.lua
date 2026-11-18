local outline_pct = 0.40
local window = require("utils.window")
local ai_terminal = require("utils.ai_terminal")

local function outline_win()
  return select(2, require("aerial.util").get_winids())
end

local function hide_visible_tools()
  local hidden = {}
  for _, terminal in ipairs(ai_terminal.loaded()) do
    local bufnr = terminal.get_active_terminal_bufnr()
    if window.find_by_buf(bufnr) then
      terminal.simple_toggle()
      table.insert(hidden, { terminal = terminal, bufnr = bufnr })
    end
  end
  return hidden
end

local function restore_hidden_tools(hidden)
  for _, tool in ipairs(hidden) do
    local bufnr = tool.bufnr
    if vim.api.nvim_buf_is_valid(bufnr) and tool.terminal.get_active_terminal_bufnr() == bufnr then
      local job = vim.b[bufnr].terminal_job_id
      if job and vim.fn.jobwait({ job }, 0)[1] == -1 then
        tool.terminal.ensure_visible()
      end
    end
  end
end

local function restore_when_closed(win, hidden)
  vim.api.nvim_create_autocmd("WinClosed", {
    pattern = tostring(win),
    once = true,
    callback = function()
      vim.schedule(function()
        restore_hidden_tools(hidden)
      end)
    end,
  })
end

local function toggle_outline()
  if outline_win() then
    require("aerial").close()
    return
  end
  local hidden = hide_visible_tools()
  local ok, error_message = pcall(require("aerial").open)
  local win = outline_win()
  if not ok or not win then
    restore_hidden_tools(hidden)
    if not ok then
      error(error_message)
    end
    return
  end
  window.set_width_pct(win, outline_pct)
  vim.w[win].aerial_set_width = true
  restore_when_closed(win, hidden)
end

return {
  {
    "stevearc/aerial.nvim",
    keys = {
      { "<localleader><tab>", toggle_outline, desc = "Toggle Outline/ToC" },
    },
    init = function()
      window.keep_width_pct({
        name = "outline_resize",
        pct = outline_pct,
        window = outline_win,
      })
    end,
    opts = {
      -- Priority list of preferred backends for aerial.
      -- This can be a filetype map (see :help aerial-filetype-map)
      backends = { "treesitter", "lsp", "markdown", "asciidoc", "man" },
      layout = {
        default_direction = "left",
      },

      -- Jump to symbol in source window when the cursor moves
      autojump = true,

      -- Use symbol tree for folding. Set to true or false to enable/disable
      -- Set to "auto" to manage folds if your previous foldmethod was 'manual'
      -- This can be a filetype map (see :help aerial-filetype-map)
      -- manage_folds = true,

      -- When you fold code with za, zo, or zc, update the aerial tree as well.
      -- Only works when manage_folds = true
      -- link_folds_to_tree = true,
    },
  },
}
