local function load_highlights(name)
  local path = vim.fn.stdpath("config") .. "/lua/highlights/" .. name .. ".lua"
  return dofile(path)
end

return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  init = function()
    -- Fix for catppuccin bufferline integration API change
    -- Reference: https://github.com/LazyVim/LazyVim/issues/6355
    -- Reference: https://github.com/LazyVim/LazyVim/pull/6354
    -- The module was moved from groups.integrations.bufferline to special.bufferline
    local bufferline_mod
    local ok1, mod1 = pcall(require, "catppuccin.groups.integrations.bufferline")
    local ok2, mod2 = pcall(require, "catppuccin.special.bufferline")

    if ok1 and mod1 then
      bufferline_mod = mod1
    elseif ok2 and mod2 then
      bufferline_mod = mod2
      -- Create the expected module path for compatibility
      package.loaded["catppuccin.groups.integrations.bufferline"] = mod2
    end

    if bufferline_mod and not bufferline_mod.get and type(bufferline_mod.get_theme) == "function" then
      bufferline_mod.get = bufferline_mod.get_theme
    end
  end,
  opts = {
    custom_highlights = function(colors)
      return load_highlights("neorg")(colors)
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
