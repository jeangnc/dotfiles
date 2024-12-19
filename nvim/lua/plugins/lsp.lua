-- changes the diagnostics style
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    local opts = {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = "rounded",
      source = "if_many",
      prefix = "● ",
      scope = "line",
    }
    vim.diagnostic.open_float(nil, opts)
  end,
})

return {
  "nvim-lspconfig",
  dependencies = {
    "saghen/blink.cmp",
  },
  opts = {
    diagnostics = {
      virtual_text = false,
      float = {
        source = "always",
        border = "rounded",
        focusable = false,
        style = "minimal",
        anchor = "SW",
      },
    },
  },
}
