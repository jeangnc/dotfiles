vim.opt_local.expandtab = false -- Use tabs (Go convention)
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4

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
