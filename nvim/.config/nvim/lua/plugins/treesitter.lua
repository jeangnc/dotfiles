return {
  {
    "nvim-treesitter/nvim-treesitter",
    commit = "main",
    opts = function(_, opts)
      opts.incremental_selection = {
        enable = false,
      }
      -- Disable auto-install to prevent corruption issues
      opts.auto_install = false
      -- Skip problematic parsers
      opts.ignore_install = { "jsonc" }
      -- Register norg parser (installed via luarocks.nvim) so LazyVim recognizes it
      opts.ensure_installed = {
        "norg",
      }

      -- Manually start treesitter for norg files (luarocks-installed parser)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "norg",
        callback = function(event)
          pcall(vim.treesitter.start, event.buf)
        end,
      })

      return opts
    end,
  },
}
