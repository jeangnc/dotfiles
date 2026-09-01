local outline_pct = 0.4

local function toggle_outline()
  local source_width = vim.api.nvim_win_get_width(0)
  if not require("aerial").toggle() then
    return
  end
  local outline_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_width(outline_win, math.floor(source_width * outline_pct))
  vim.w[outline_win].aerial_set_width = true
end

return {
  {
    "stevearc/aerial.nvim",
    keys = {
      { "<localleader><tab>", toggle_outline, desc = "Toggle Outline/ToC" },
    },
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
