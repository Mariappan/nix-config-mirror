local M = {}

local vim = vim

function M.map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function M.mapBuf(buf, mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_buf_set_keymap(buf, mode, lhs, rhs, options)
end

M.map("i", "jk", "<esc>")
M.map("i", "<esc>", "<nop>")

M.map("n", ";", ":", { nowait = true, silent = false })
M.map("v", ";", ":", { nowait = true, silent = false })

M.map("n", "[[", "[[zz")
M.map("n", "]]", "]]zz")

M.map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
M.map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
M.map("v", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
M.map("v", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

M.map("n", "gV", "`[V`]") -- Select last pasted lines

M.map("n", "Y", "y$") -- Yank till end of line

M.map("n", "ZZ", "<nop>")
M.map("n", "ZQ", "<nop>")

M.map("v", "u", "<nop>")
M.map("v", "U", "<nop>")

M.map("n", "X", "<cmd>bnext<cr>") -- Move between buffers
M.map("n", "W", "<cmd>w<cr>")
M.map("n", "Q", "<cmd>Sayonara<cr>")

M.map("n", "<Leader>r", ":vsplit $MYVIMRC<cr>")
M.map("n", "<Leader>=", "gg=G`'") -- Indent the entire file

-- Alignment in visual mode
M.map("v", ">", ">gv")
M.map("v", "<", "<gv")

M.map("v", "gy", '"*y')
M.map("n", "gp", '"*p')
M.map("n", "gP", '"*P')

M.map("v", "<c-]>", "g<c-]>")
M.map("n", "<c-]>", "g<c-]>")
M.map("n", "gt", "g<c-]>")

M.map("v", "g<c-]>", "<c-]>")
M.map("n", "g<c-]>", "<c-]>")

M.map("n", "+", "<c-a>")
M.map("n", "-", "<c-x>")

M.map("n", "H", "^")
M.map("n", "L", "g_")
M.map("v", "H", "^")
M.map("v", "L", "g_")

M.map("v", "gJ", ":join<cr>")

-- For fold toggle
-- M.map("n", "<Space>", "za")

M.map("n", "<Leader>d", '"_d')
M.map("v", "<Leader>d", '"_d')

-- terminal M.mappings
M.map("t", "<Esc>", "<c-\\><c-n><esc><cr>")
M.map("t", "<Leader>,", "<c-\\><c-n>:bnext<cr>")
M.map("t", "<Leader>.", "<c-\\><c-n>:bprevious<cr>")

M.map("v", "<expr>y", 'my"' .. vim.v.register .. "y`y")

return M
