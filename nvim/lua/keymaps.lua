-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- RC custom keymaps
vim.keymap.set('n', '<C-t>', ':terminal<CR>:startinsert<CR>', { noremap = true, silent = true })
vim.keymap.set({ 'n', 'v' }, '<leader>pp', '<cmd>w<CR><cmd>Ex<CR>')
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

vim.keymap.set('v', '<C-k>', '<Plug>SchleppUp', { noremap = true })
vim.keymap.set('v', '<C-j>', '<Plug>SchleppDown', { noremap = true })

vim.keymap.set('n', ':call setqflist([], "r")<CR>', '<leader>qx', { desc = '[Q]uick[f]ix list clear[x]' })
vim.keymap.set('n', '<leader>qr', ':.Reject<CR>', { desc = '[Q]uick[f]ix list [r]eject current item' })
vim.keymap.set('n', '<leader>qd', ':Reject<CR>', { desc = '[Q]uick[f]ix list [d]elete items' })
vim.keymap.set('n', '<leader>qo', ':copen<CR>', { desc = '[Q]uick[f]ix list [o]pen ql window' })
vim.keymap.set('n', '<leader>qc', ':cclose<CR>', { desc = '[Q]uick[f]ix list [c]lose ql window' })
vim.keymap.set('n', '<leader>qn', ':cnext<CR>', { desc = '[Q]uick[f]ix list [n]ext item' })
vim.keymap.set('n', '<leader>qp', ':cprev<CR>', { desc = '[Q]uick[f]ix list [p]revious item' })
vim.keymap.set(
  'n',
  '<leader>qa',
  ':call setqflist([{"lnum": line("."), "col": 1, "bufnr": bufnr("%"), "text": getline(".")}], "a")<CR>',
  { desc = '[Q]uick[f]ix list [a]dd current line' }
)

local opts = { noremap = true, silent = true }
vim.keymap.set({ 'i', 's' }, '<C-j>', "<cmd>lua require'luasnip'.jump(1)<CR>", opts)
vim.keymap.set({ 'i', 's' }, '<C-k>', "<cmd>lua require'luasnip'.jump(-1)<CR>", opts)

vim.keymap.set('n', '<leader>cf', function()
  vim.fn.setreg('+', vim.fn.expand '%:t')
end, { desc = 'Copy filename to clipboard' })

vim.keymap.set('n', '<leader>cr', function()
  vim.fn.setreg('+', vim.fn.expand '%:.')
end, { desc = 'Copy relative file path to clipboard' })

vim.keymap.set('n', '<leader>cw', function()
  vim.fn.setreg('+', vim.fn.getcwd())
end, { desc = 'Copy current working directory to clipboard' })

vim.keymap.set('n', '<leader>cp', function()
  vim.fn.setreg('+', vim.fn.expand '%:p')
end, { desc = 'Copy full file path to clipboard' })

-- vim: ts=2 sts=2 sw=2 et
