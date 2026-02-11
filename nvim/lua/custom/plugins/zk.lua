-- zk-nvim: note-taking with wikilinks, backlinks, and search via telescope
return {
  'zk-org/zk-nvim',
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    require('zk').setup {
      picker = 'telescope',
      lsp = {
        config = {
          cmd = { 'zk', 'lsp' },
          name = 'zk',
        },
        auto_attach = {
          enabled = true,
          filetypes = { 'markdown' },
        },
      },
    }

    -- Global keymaps (work anywhere)
    vim.keymap.set('n', '<leader>zn', function()
      vim.ui.input({ prompt = 'Note title: ' }, function(title)
        if title then
          require('zk').new { title = title }
        end
      end)
    end, { desc = 'zk [n]ew note' })

    vim.keymap.set('n', '<leader>zo', function()
      require('zk').edit({}, { title = 'Zk Notes' })
    end, { desc = 'zk [o]pen notes' })

    vim.keymap.set('n', '<leader>zt', '<Cmd>ZkTags<CR>', { desc = 'zk [t]ags' })

    vim.keymap.set('n', '<leader>zf', function()
      vim.ui.input({ prompt = 'Search notes: ' }, function(query)
        if query then
          require('zk').edit({ match = { query } }, { title = 'Zk Search: ' .. query })
        end
      end)
    end, { desc = 'zk [f]ind notes' })

    vim.keymap.set('v', '<leader>zf', ":'<,'>ZkMatch<CR>", { desc = 'zk [f]ind matching notes' })

    -- Buffer-local keymaps for markdown files in zk notebooks
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'markdown',
      callback = function(args)
        local bufnr = args.buf
        local path = vim.api.nvim_buf_get_name(bufnr)
        if require('zk.util').notebook_root(path) then
          local opts = { buffer = bufnr }
          vim.keymap.set('n', '<leader>zb', '<Cmd>ZkBacklinks<CR>', vim.tbl_extend('force', opts, { desc = 'zk [b]acklinks' }))
          vim.keymap.set('n', '<leader>zl', '<Cmd>ZkLinks<CR>', vim.tbl_extend('force', opts, { desc = 'zk [l]inks' }))
          vim.keymap.set('n', '<CR>', '<Cmd>lua vim.lsp.buf.definition()<CR>', vim.tbl_extend('force', opts, { desc = 'Follow wikilink' }))
        end
      end,
    })
  end,
}
