-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here


-- to speed up browser searches
vim.keymap.set("n", "<leader>sB", function()
  vim.ui.input({ prompt = "Search query: " }, function(query)
    if query then
      local url = "https://www.google.com/search?q=" .. vim.fn.escape(query, " ")
      vim.fn.jobstart({ "open", url }, { detach = true })
    end
  end)
end, { desc = "Browser Search" })

-- buffers
vim.keymap.set(
  "n",
  "<leader>ba",
  "<cmd>BufferLineGroupClose ungrouped<cr>",
  { desc = "Delete All Buffers", silent = true, noremap = true }
)

vim.keymap.set("n", "<leader>bn", "<cmd>enew<cr>", { desc = "New Buffer", silent = true, noremap = true })

-- misc
vim.keymap.set(
  "n",
  "<leader>0",
  "<cmd>Telescope live_grep<cr>",
  { desc = "Grep (Root Dir)", silent = true, noremap = true }
)

-- yanks to global clipboard
vim.keymap.set({ "n", "v", "o" }, "<leader>y", '"+y', { desc = "Yank to Clipboard", silent = true, noremap = true })
vim.keymap.set("n", "<leader>Y", ":%y+<cr>", { desc = "Yank File to Clipboard", silent = true, noremap = true })
