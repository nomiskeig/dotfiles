local opts = {noremap = true, silent = true}
local term_opts = {silent = true}

local keymap = vim.api.nvim_set_keymap
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Better window navigation
--keymap("n", "<C-h>", "<C-w>h", opts)
--keymap("n", "<C-j>", "<C-w>j", opts)
--keymap("n", "<C-k>", "<C-w>k", {silent = true})
--keymap("n", "<C-l>", "<C-w>l", opts)

vim.keymap.set('n', '<C-h>', "<C-w>h", opts)
vim.keymap.set('n', '<C-l>', "<C-w>l", opts)
vim.keymap.set('n', '<C-j>', "<C-w>j", opts)
vim.keymap.set('n', '<C-k>', "<C-w>k", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)


-- Faster exit to normal mode
keymap("i", "jk", "<ESC>", opts)

-- DAP --

keymap("n", "<F5>", ":lua require'dap'.step_over()<CR>", opts)
keymap("n", "<F6>", ":lua require'dap'.step_into()<CR>", opts)
keymap("n", "<F7", ":lua require'dap'.repl.toggle()<CR>", opts)
 -- Resize windows with arrow keys
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)
--keymap("n", "<leader>tm", ":lua  require('neotest').run.run({strategy = 'dap'})<CR> ", opts)
