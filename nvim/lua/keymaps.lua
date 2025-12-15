-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps (use Trouble via <leader>xx instead)

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
vim.keymap.set({ 'n', 'v' }, '<leader>pp', '<cmd>w<CR><cmd>Oil<CR>', { desc = 'Save and open Oil file browser' })

-- Diagnostics navigation (both bracket-style and <leader>d unified)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev, { desc = '[P]revious diagnostic' })
vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_next, { desc = '[N]ext diagnostic' })
vim.keymap.set('n', '<leader>de', vim.diagnostic.open_float, { desc = 'Floating diagnostic [E]rror' })

vim.keymap.set('v', '<C-k>', '<Plug>SchleppUp', { noremap = true })
vim.keymap.set('v', '<C-j>', '<Plug>SchleppDown', { noremap = true })

-- Quickfix keymaps replaced by Trouble (<leader>x*)

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

vim.keymap.set('n', '<leader>cl', function()
  local line = vim.fn.line '.'
  local filepath = vim.fn.expand '%:.'
  vim.fn.setreg('+', filepath .. ':' .. line)
  vim.notify('Copied: ' .. filepath .. ':' .. line)
end, { desc = 'Copy [L]ine reference (file:line)' })

vim.keymap.set('n', '<leader>cd', function()
  local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line '.' - 1 })
  if #diagnostics == 0 then
    vim.notify('No diagnostics on current line', vim.log.levels.WARN)
    return
  end
  local messages = {}
  for _, d in ipairs(diagnostics) do
    local severity = vim.diagnostic.severity[d.severity]:lower()
    local source = d.source and (' (' .. d.source .. ')') or ''
    table.insert(messages, severity .. ': ' .. d.message .. source)
  end
  local result = table.concat(messages, '\n')
  vim.fn.setreg('+', result)
  vim.notify('Copied ' .. #diagnostics .. ' diagnostic(s)')
end, { desc = 'Copy [D]iagnostic (current line)' })

vim.keymap.set('n', '<leader>cD', function()
  local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line '.' - 1 })

  local filepath = vim.fn.expand '%:.'
  local lnum = vim.fn.line '.'
  local col = vim.fn.col '.'
  local ft = vim.bo.filetype

  -- Get context lines (3 above and 3 below)
  local start_line = math.max(1, lnum - 3)
  local end_line = math.min(vim.fn.line '$', lnum + 3)
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

  -- Build context with line numbers
  local context_lines = {}
  for i, line in ipairs(lines) do
    local line_num = start_line + i - 1
    local marker = line_num == lnum and ' --> ' or '     '
    table.insert(context_lines, string.format('%s%3d | %s', marker, line_num, line))
  end

  local result
  if #diagnostics > 0 then
    -- Build diagnostic messages
    local diag_messages = {}
    for _, d in ipairs(diagnostics) do
      local severity = vim.diagnostic.severity[d.severity]:lower()
      local source = d.source and (' (' .. d.source .. ')') or ''
      local code = d.code and (' [' .. d.code .. ']') or ''
      table.insert(diag_messages, severity .. ': ' .. d.message .. code .. source)
    end

    result = string.format(
      'File: %s:%d:%d\n%s\n\nContext:\n```%s\n%s\n```',
      filepath,
      lnum,
      col,
      table.concat(diag_messages, '\n'),
      ft,
      table.concat(context_lines, '\n')
    )
    vim.notify('Copied diagnostic with context for LLM')
  else
    -- No diagnostics - just copy reference with context
    result = string.format(
      'File: %s:%d:%d\n\nContext:\n```%s\n%s\n```',
      filepath,
      lnum,
      col,
      ft,
      table.concat(context_lines, '\n')
    )
    vim.notify('Copied line reference with context for LLM')
  end

  vim.fn.setreg('+', result)
end, { desc = 'Copy context for LLM (with diagnostic if present)' })

vim.keymap.set('n', '<leader>ca', function()
  local diagnostics = vim.diagnostic.get(0)
  if #diagnostics == 0 then
    vim.notify('No diagnostics in buffer', vim.log.levels.WARN)
    return
  end

  local filepath = vim.fn.expand '%:.'
  local messages = {}

  for _, d in ipairs(diagnostics) do
    local severity = vim.diagnostic.severity[d.severity]:lower()
    local source = d.source and (' (' .. d.source .. ')') or ''
    local code = d.code and (' [' .. d.code .. ']') or ''
    table.insert(messages, string.format('%s:%d:%d - %s: %s%s%s', filepath, d.lnum + 1, d.col + 1, severity, d.message, code, source))
  end

  local result = table.concat(messages, '\n')
  vim.fn.setreg('+', result)
  vim.notify('Copied ' .. #diagnostics .. ' diagnostic(s) from buffer')
end, { desc = 'Copy [A]ll diagnostics in buffer' })

-- Buffer management (<leader>b)
vim.keymap.set('n', '<leader>bd', function()
  local buf = vim.api.nvim_get_current_buf()
  if vim.bo[buf].modified then
    local choice = vim.fn.confirm('Buffer has unsaved changes. Save before closing?', '&Yes\n&No\n&Cancel', 1)
    if choice == 1 then
      vim.cmd 'write'
      vim.cmd 'bdelete'
    elseif choice == 2 then
      vim.cmd 'bdelete!'
    end
  else
    vim.cmd 'bdelete'
  end
end, { desc = '[D]elete buffer' })

vim.keymap.set('n', '<leader>bD', '<cmd>bdelete!<cr>', { desc = '[D]elete buffer (force)' })

vim.keymap.set('n', '<leader>bo', function()
  local current = vim.api.nvim_get_current_buf()
  local buffers = vim.api.nvim_list_bufs()
  local deleted = 0
  for _, buf in ipairs(buffers) do
    if buf ~= current and vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
      vim.api.nvim_buf_delete(buf, { force = false })
      deleted = deleted + 1
    end
  end
  vim.notify('Deleted ' .. deleted .. ' buffer(s)')
end, { desc = 'Delete [O]ther buffers' })

vim.keymap.set('n', '<leader>ba', function()
  local buffers = vim.api.nvim_list_bufs()
  local deleted = 0
  for _, buf in ipairs(buffers) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
      vim.api.nvim_buf_delete(buf, { force = false })
      deleted = deleted + 1
    end
  end
  vim.notify('Deleted ' .. deleted .. ' buffer(s)')
end, { desc = 'Delete [A]ll buffers' })

vim.keymap.set('n', '<leader>bb', '<cmd>Telescope buffers<cr>', { desc = '[B]uffer picker' })

vim.keymap.set('n', '<leader>bx', function()
  vim.cmd 'enew'
  vim.bo.buftype = 'nofile'
  vim.bo.bufhidden = 'wipe'
  vim.bo.swapfile = false
  vim.notify 'Scratch buffer created'
end, { desc = 'Scratch buffer' })

vim.keymap.set('n', '<leader>bm', function()
  vim.cmd 'enew'
  vim.bo.buftype = 'nofile'
  vim.bo.bufhidden = 'wipe'
  vim.bo.swapfile = false
  vim.bo.filetype = 'markdown'
  vim.notify 'Markdown scratch buffer created'
end, { desc = '[M]arkdown scratch buffer' })

-- Macros (<leader>m)
vim.keymap.set('n', '<leader>mq', function()
  if vim.fn.reg_recording() ~= '' then
    vim.cmd 'normal! q'
    vim.notify 'Macro recorded to register q'
  else
    vim.cmd 'normal! qq'
    vim.notify 'Recording macro to register q...'
  end
end, { desc = 'Toggle macro recording (q)' })

vim.keymap.set('n', '<leader>mr', '@q', { desc = '[R]un macro (q)' })

vim.keymap.set('n', '<leader>mR', function()
  local reg = vim.fn.getcharstr()
  if reg and reg:match '[a-zA-Z0-9]' then
    vim.cmd('normal! @' .. reg)
  end
end, { desc = '[R]un macro (prompt register)' })

vim.keymap.set('n', '<leader>me', function()
  local macro_content = vim.fn.getreg 'q'
  if macro_content == '' then
    vim.notify('Register q is empty', vim.log.levels.WARN)
    return
  end

  -- Create scratch buffer for editing
  vim.cmd 'new'
  vim.bo.buftype = 'nofile'
  vim.bo.bufhidden = 'wipe'
  vim.bo.swapfile = false

  -- Insert macro content
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { macro_content })

  vim.notify 'Edit macro, then <leader>me again to save (or :w)'

  -- Set up autocmd to save back to register on write or leave
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_create_autocmd({ 'BufWriteCmd', 'BufLeave' }, {
    buffer = bufnr,
    once = true,
    callback = function()
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      local new_macro = table.concat(lines, '')
      vim.fn.setreg('q', new_macro)
      vim.notify 'Macro saved to register q'
      if vim.api.nvim_buf_is_valid(bufnr) then
        vim.api.nvim_buf_delete(bufnr, { force = true })
      end
    end,
  })
end, { desc = '[E]dit macro (q)' })

vim.keymap.set('n', '<leader>ml', '<cmd>Telescope registers<cr>', { desc = '[L]ist registers' })

vim.keymap.set('v', '<leader>mp', ':norm @q<cr>', { desc = '[P]lay macro on selection' })

-- vim: ts=2 sts=2 sw=2 et
