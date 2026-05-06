local augroup = require("utils.common").augroup

local M = {}

function M.find_by_buf(bufnr)
  if not bufnr then
    return nil
  end
  return vim.fn.win_findbuf(bufnr)[1]
end

function M.set_width_pct(win, pct)
  vim.api.nvim_win_set_width(win, math.floor(vim.o.columns * pct))
end

function M.keep_width_pct(opts)
  augroup(opts.name, function(autocmd)
    autocmd("VimResized", {
      callback = function()
        local win = opts.window()
        if win and vim.api.nvim_win_is_valid(win) then
          M.set_width_pct(win, opts.pct)
        end
      end,
    })
  end)
end

return M
