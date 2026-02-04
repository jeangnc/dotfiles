local function load_highlights(name)
  local path = vim.fn.stdpath("config") .. "/lua/highlights/" .. name .. ".lua"
  return dofile(path)
end

return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  opts = {
    custom_highlights = function(colors)
      local neorg_highlights = load_highlights("neorg")(colors)
      local lua_highlights = load_highlights("lua")(colors)
      return vim.tbl_extend("force", neorg_highlights, lua_highlights)
    end,
    color_overrides = {
      mocha = {
        -- base = "#000000",
        -- mantle = "#000000",
        -- crust = "#000000",
      },
    },
    integrations = {
      cmp = false,
      flash = true,
      fzf = true,
      grug_far = true,
      gitsigns = true,
      headlines = false,
      illuminate = false,
      indent_blankline = { enabled = false },
      leap = false,
      lsp_trouble = true,
      mason = true,
      markdown = true,
      mini = true,
      native_lsp = {
        enabled = true,
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
      },
      navic = { enabled = false },
      neotest = true,
      neotree = true,
      noice = true,
      notify = true,
      semantic_tokens = true,
      snacks = true,
      treesitter = true,
      treesitter_context = true,
      which_key = true,
    },
  },
}
