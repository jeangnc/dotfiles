local outline_pct = 0.40
local window = require("utils.window")

local function outline_win()
  return select(2, require("aerial.util").get_winids())
end

local function toggle_outline()
  if not require("aerial").toggle() then
    return
  end
  local win = vim.api.nvim_get_current_win()
  window.set_width_pct(win, outline_pct)
  vim.w[win].aerial_set_width = true
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
