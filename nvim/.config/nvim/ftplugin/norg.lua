-- Neorg filetype-specific configuration

-- Text formatting settings
vim.opt_local.textwidth = 120
vim.opt_local.colorcolumn = "120"

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

-- ============================================================================
-- Neorg Backup Functionality
-- ============================================================================

local neorg_backup_group = vim.api.nvim_create_augroup("neorg_backup", { clear = true })

-- Auto-commit neorg files after save, move, add, or remove
vim.api.nvim_create_autocmd({"BufWritePost", "BufNewFile", "BufDelete"}, {
  group = neorg_backup_group,
  pattern = "*.norg",
  callback = function(event)
    local file_path = vim.fn.expand("%:p")
    local neorg_utils = require("utils.neorg")
    local git_utils = require("utils.git")

    -- Only commit if file is inside a neorg workspace
    if not neorg_utils.is_file_in_workspace(file_path) then
      return
    end

    -- Handle different event types
    if event.event == "BufDelete" then
      -- For deleted files, we need to commit the removal
      vim.schedule(function()
        git_utils.async_remove_and_commit(file_path, "Backup")
      end)
    else
      -- For new files and saves, add and commit
      vim.schedule(function()
        git_utils.async_add_and_commit(file_path, "Backup")
      end)
    end
  end,
  desc = "Auto-commit neorg files in workspace with 'Backup' message"
})

-- Handle file moves/renames
vim.api.nvim_create_autocmd("User", {
  group = neorg_backup_group,
  pattern = "NeorgFileMoved",
  callback = function(event)
    local old_path = event.data.old_path
    local new_path = event.data.new_path
    local neorg_utils = require("utils.neorg")
    local git_utils = require("utils.git")

    -- Only process if both paths are in neorg workspace
    if neorg_utils.is_file_in_workspace(old_path) and neorg_utils.is_file_in_workspace(new_path) then
      vim.schedule(function()
        git_utils.async_move_and_commit(old_path, new_path, "Backup")
      end)
    end
  end,
  desc = "Auto-commit neorg file moves in workspace"
})
