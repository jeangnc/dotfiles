return {
  "3rd/image.nvim",
  build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
  config = function()
    require("image").setup({
      backend = "kitty",
      processor = "magick_cli",
      integrations = {
        neorg = {
          enabled = true,
          filetypes = { "norg" },
        },
      },

      window_overlap_clear_enabled = true,
      editor_only_render_when_focused = true, -- auto show/hide images when the editor gains/looses focus
      tmux_show_only_in_active_window = true,
    })
  end,
}
