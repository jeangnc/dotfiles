-- Fix for LazyVim/Catppuccin compatibility
-- Adds missing get() method as alias to get_theme()

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local ok, bufferline_integration = pcall(require, "catppuccin.groups.integrations.bufferline")
    if ok and not bufferline_integration.get and bufferline_integration.get_theme then
      bufferline_integration.get = bufferline_integration.get_theme
    end
  end,
  once = true,
})