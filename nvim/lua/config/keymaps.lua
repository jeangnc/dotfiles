-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
local unmap = vim.api.nvim_del_keymap

-- to speed up browser searches
map("n", "<leader>sB", function()
  vim.ui.input({ prompt = "Search query: " }, function(query)
    if query then
      local url = "https://www.google.com/search?q=" .. vim.fn.escape(query, " ")
      vim.fn.jobstart({ "open", url }, { detach = true })
    end
  end)
end, { desc = "Browser Search" })

--
-- buffers
--
map("n", "<leader>bdd", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })

map("n", "<leader>bdo", function()
  Snacks.bufdelete.other()
end, { desc = "Delete Other Buffers" })

map("n", "<leader>bdD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

-- removes unused buffer keymaps
unmap("n", "<leader><tab>d")
unmap("n", "<leader>bd")
unmap("n", "<leader>bl")
unmap("n", "<leader>br")
unmap("n", "<leader>bD")
unmap("n", "<leader>bo")
unmap("n", "<leader>bp")
unmap("n", "<leader>bP")

--
-- windows
--
map("n", "<leader>wc", "<cmd>close<cr>", { desc = "Close Window" })

--
-- tabs
--

map("n", "<leader><tab>c", "<cmd>tabclose<cr>", { desc = "Close tab" })

--
-- misc
--

-- shortcut to live grep
vim.keymap.set(
  "n",
  "<leader>0",
  "<cmd>Telescope live_grep<cr>",
  { desc = "Grep (Root Dir)", silent = true, noremap = true }
)

-- yanks to global clipboard
vim.keymap.set({ "n", "v", "o" }, "<leader>y", '"+y', { desc = "Yank to Clipboard", silent = true, noremap = true })
vim.keymap.set("n", "<leader>Y", ":%y+<cr>", { desc = "Yank File to Clipboard", silent = true, noremap = true })
