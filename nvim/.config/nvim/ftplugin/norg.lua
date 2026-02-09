-- ============================================================================
-- Options
-- ============================================================================

vim.opt_local.textwidth = 100
vim.opt_local.colorcolumn = "100"

-- Ensure line breaks occur at spaces/words, not mid-word
vim.opt_local.formatoptions:append("t")

-- ============================================================================
-- Keymaps
-- ============================================================================

vim.keymap.set("n", "gl", "<plug>(neorg.external.hop-extras.hop-link)", { desc = "Hop link", buffer = true })
vim.keymap.set(
    "n",
    "<C-Space>",
    "<Plug>(neorg.qol.todo-items.todo.task-cycle)",
    { desc = "Cycle todo state", buffer = true }
)
vim.keymap.set({ "n", "v", "o" }, "<C-E>", "<cmd>Neorg toc<cr>", { desc = "Toggle ToC", buffer = true })
vim.keymap.set(
    { "n", "v", "o" },
    "<F12>",
    "<cmd>Neorg toggle-concealer<cr>",
    { desc = "Toggle concealer", buffer = true }
)
vim.keymap.set({ "n", "i", "o" }, "<Tab>", function()
    vim.cmd("startinsert")
    vim.cmd('lua require("neorg.modules.core.itero.module").public.next_iteration_cr()')
end, { desc = "Next iteration", buffer = true })

-- Journal-specific keymaps (only in .journalfiles directory)
local current_file = vim.fn.expand("%:p")
if current_file:match("%.journalfiles/") then
    vim.keymap.set("n", "<localleader>jc", function()
        require("utils.neorg").continue_journal()
    end, { desc = "Continue journal from previous entry", buffer = true })
end

-- ============================================================================
-- Auto-indent
-- ============================================================================

vim.api.nvim_create_autocmd({ "BufWritePre", "InsertLeave" }, {
    group = vim.api.nvim_create_augroup("NorgAutoIndent", { clear = true }),
    desc = "Auto-indent norg buffer on save and insert leave",
    buffer = 0,
    callback = function()
        local win = vim.api.nvim_get_current_win()
        local cursor = vim.api.nvim_win_get_cursor(win)

        pcall(function()
            vim.api.nvim_command("undojoin")
        end)

        vim.cmd("silent keepjumps normal! gg=G")
        pcall(vim.api.nvim_win_set_cursor, win, cursor)
    end,
})

-- ============================================================================
-- Neorg Backup Functionality
-- ============================================================================

require("utils.backup").setup({
    augroup = "neorg_backup",
    pattern = "*.norg",
    should_backup = require("utils.neorg").is_file_in_workspace,
    events = {
        file_deleted = "NeorgFileDeleted",
        file_copied = "NeorgFileCopied",
        file_moved = "NeorgFileMoved",
    },
})
