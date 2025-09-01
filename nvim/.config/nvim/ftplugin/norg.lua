-- Neorg filetype-specific configuration

-- Text formatting settings
vim.opt_local.textwidth = 100
vim.opt_local.colorcolumn = "100"

-- Neorg-specific keymaps
vim.keymap.set("n", "gl", "<plug>(neorg.external.hop-extras.hop-link)", { buffer = true })
vim.keymap.set({ "n", "v", "o" }, "<C-E>", "<cmd>Neorg toc<cr>", { desc = "Toggle ToC", buffer = true })
vim.keymap.set(
  { "n", "v", "o" },
  "<F12>",
  "<cmd>Neorg toggle-concealer<cr>",
  { desc = "Toggle concealer", buffer = true }
)
vim.keymap.set(
  { "n" },
  "<localleader>am",
  "<cmd>Neorg inject-metadata<cr>",
  { desc = "Inject metadata", buffer = true }
)
vim.keymap.set({ "n", "i", "o" }, "<Tab>", function()
  vim.cmd("startinsert")
  vim.cmd('lua require("neorg.modules.core.itero.module").public.next_iteration_cr()')
end, { desc = "", buffer = true })

-- Auto-indent on save and when leaving insert mode for .norg files
vim.api.nvim_create_autocmd({ "BufWritePre", "InsertLeave" }, {
  pattern = "*.norg",
  callback = function()
    local view = vim.fn.winsaveview()
    vim.cmd("silent! normal! gg=G")
    vim.fn.winrestview(view)
  end,
})

-- LSP configuration for neorg files
vim.api.nvim_create_autocmd("LspAttach", {
  pattern = "*.norg",
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    if client.server_capabilities.completionProvider then
      vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
    end

    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  end,
})
