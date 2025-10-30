-- changes the diagnostics style
-- Commented out: Auto-showing diagnostics on CursorHold causes high CPU usage
-- because it fires every updatetime (200ms), forcing kitty to redraw constantly.
-- Use manual diagnostics instead: K (hover) or <leader>cd (diagnostics)
--[[
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
--]]

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
