-- Go-specific settings
vim.opt_local.expandtab = false -- Use tabs (Go convention)
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4

-- Auto-organize imports on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    for _, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          vim.lsp.util.apply_workspace_edit(r.edit, "utf-8")
        else
          vim.lsp.buf.execute_command(r.command)
        end
      end
    end
  end,
})

-- Note: All keybindings are already configured globally via LazyVim/LSP:
--
-- Code actions (struct tags, impl, fill struct):
--   <leader>ca - Code actions menu
--   <leader>cA - Source actions
--
-- Code lenses (run tests inline):
--   <leader>cc - Run codelens
--   <leader>cC - Refresh codelens
--
-- Testing (via neotest):
--   <leader>tt - Run nearest test
--   <leader>tT - Run all tests in file
--   <leader>tr - Run last test
--   <leader>ts - Toggle test summary
--   <leader>to - Show test output
