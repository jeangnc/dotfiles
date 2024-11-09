return {
  -- Setup orgmode
  {
    "nvim-orgmode/orgmode",
    event = "VeryLazy",
    ft = { "org" },
    config = function()
      require("orgmode").setup({
        org_agenda_files = "~/orgfiles/**/*",
        org_default_notes_file = "~/orgfiles/refile.org",
      })
    end,
  },
  -- Setup orgmode completion
  {
    "nvim-cmp",
    opts = function(_, opts)
      table.insert(opts.sources, {
        name = "orgmode",
      })
    end,
  },
}
