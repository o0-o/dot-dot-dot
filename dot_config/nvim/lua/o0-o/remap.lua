-- Disable the space key in normal and visual mode (used as <leader>)
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true, desc = "Disable <Space>" })

-- Set <leader> and <localleader> to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Open netrw (file explorer) with <leader>pv
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, { desc = "Open netrw" })

-- Navigate between buffers
vim.keymap.set("n", "L", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "H", ":bprevious<CR>", { desc = "Previous buffer" })

-- Move selected lines down/up in visual mode with J/K
vim.keymap.set('v', 'J', "':m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set('v', 'K', "':m '>-2<CR>gv=gv", { desc = "Move selection up" })

-- Join lines in normal mode but preserve cursor position
vim.keymap.set('n', 'J', 'mzJ`z', { desc = "Join lines (preserve cursor)" })

-- Center screen after scrolling
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = "Scroll down (centered)" })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = "Scroll up (centered)" })

-- Center screen after search next/prev
vim.keymap.set('n', 'n', 'nzzzv', { desc = "Search next (centered)" })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = "Search prev (centered)" })

-- Reindent the entire buffer
vim.keymap.set("n", "<leader>=", "mzgg=G`z", { desc = "Reindent entire buffer and restore cursor" })

-- Select the entire buffer in visual mode
vim.keymap.set("n", "<leader>a", "ggVG", { desc = "Select entire buffer" })

-- Yank to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Yank line to system clipboard" })

-- Disable the Q command (which enters Ex mode)
vim.keymap.set('n', 'Q', '<nop>', { desc = "Disable Q (Ex mode)" })

-- Navigate quickfix (<C-k>/<C-j>) and location list (<leader>k/<leader>j) entries, centering the view
vim.keymap.set('n', '<C-k>', '<cmd>cnext<CR>zz', { desc = "Next quickfix" })
vim.keymap.set('n', '<C-j>', '<cmd>cprev<CR>zz', { desc = "Previous quickfix" })
vim.keymap.set('n', '<leader>k', '<cmd>lnext<CR>zz', { desc = "Next location" })
vim.keymap.set('n', '<leader>j', '<cmd>lprev<CR>zz', { desc = "Previous location" })

-- Substitute word under cursor (globally, case-insensitive) with confirmation cursor ready
vim.keymap.set('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], {
  desc = "Substitute word under cursor",
})

-- Undecided on how to close buffers
vim.keymap.set("n", "<leader>bd", "<cmd>bd<CR>", { desc = "Close buffer" })
vim.keymap.set("n", "<leader>x", "<cmd>bd<CR>", { desc = "Close buffer (alt)" })

-- Save the file with <leader><leader>
vim.keymap.set("n", "<leader><leader>", function()
  vim.cmd("w")
end, { desc = "Save file" })

-- Rewrap paragraph with `gqap` (used for comments usually)
vim.keymap.set("n", "<leader>wr", "gqap", { desc = "Rewrap comment paragraph" })

-- In insert mode, if line is just a comment leader (like "//"), pressing <CR> clears it instead of inserting a new line.
vim.keymap.set("i", "<CR>", function()
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  local commentstring = vim.bo.commentstring:gsub("%%s", ""):gsub("%s+$", "")
  if vim.trim(line) == commentstring then
    vim.schedule(function()
      vim.api.nvim_buf_set_lines(0, row - 1, row, false, { "" })
    end)
    return ""
  else
    return "\r"
  end
end, { expr = true, desc = "Smart exit from comment block" })
