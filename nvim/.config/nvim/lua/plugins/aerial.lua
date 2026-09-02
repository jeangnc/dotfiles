local outline_pct = 0.40
local window = require("utils.window")

local right_tools = {
  {
    visible = function()
      local terminal = require("claudecode.terminal")
      return window.find_by_buf(terminal.get_active_terminal_bufnr()) ~= nil
    end,
    hide = function()
      require("claudecode.terminal").simple_toggle()
    end,
    show = function()
      require("claudecode.terminal").ensure_visible()
    end,
  },
}

local function outline_win()
  return select(2, require("aerial.util").get_winids())
end

local function hide_visible_tools()
  local hidden = {}
  for _, tool in ipairs(right_tools) do
    if tool.visible() then
      tool.hide()
      table.insert(hidden, tool)
    end
  end
  return hidden
end

local function restore_when_closed(win, hidden)
  vim.api.nvim_create_autocmd("WinClosed", {
    pattern = tostring(win),
    once = true,
    callback = function()
      vim.schedule(function()
        for _, tool in ipairs(hidden) do
          tool.show()
        end
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
  require("aerial").open()
  local win = vim.api.nvim_get_current_win()
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
