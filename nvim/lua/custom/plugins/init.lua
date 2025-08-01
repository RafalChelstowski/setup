-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {

  {
    'nvimdev/guard.nvim',
    -- Builtin configuration, optional
    dependencies = {
      'nvimdev/guard-collection',
    },
    init = function()
      local ft = require 'guard.filetype'

      -- multiple files register
      ft('typescript,javascript,typescriptreact,json,html,css,markdown'):fmt 'prettier'
      ft('c,cpp,glsl,java'):fmt 'clang-format'
      ft('lua'):fmt 'stylua'

      -- call setup LAST
      vim.g.guard_config = {
        -- format on write to buffer
        fmt_on_save = false,
      }

      vim.keymap.set({ 'n', 'v' }, '<leader>ff', '<cmd>Guard fmt<CR>')
    end,
  },

  'romainl/vim-qf',

  {
    'kevinhwang91/nvim-bqf',
    ft = 'qf',
    opts = {
      auto_resize_height = true,
    },
  },

  {
    'f-person/auto-dark-mode.nvim',
    opts = {
      update_interval = 500000,
      set_dark_mode = function()
        vim.api.nvim_set_option_value('background', 'dark', {})
        vim.cmd 'colorscheme catppuccin-mocha'
      end,
      set_light_mode = function()
        vim.api.nvim_set_option_value('background', 'light', {})
        vim.cmd 'colorscheme catppuccin-latte'
      end,
    },
    init = function()
      require('auto-dark-mode').init()
    end,
  },

  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    init = function()
      local harpoon = require 'harpoon'

      -- REQUIRED
      harpoon:setup()
      -- REQUIRED

      harpoon:extend {
        UI_CREATE = function(cx)
          vim.keymap.set('n', '<C-v>', function()
            harpoon.ui:select_menu_item { vsplit = true }
          end, { buffer = cx.bufnr })

          vim.keymap.set('n', '<C-x>', function()
            harpoon.ui:select_menu_item { split = true }
          end, { buffer = cx.bufnr })

          vim.keymap.set('n', '<C-t>', function()
            harpoon.ui:select_menu_item { tabedit = true }
          end, { buffer = cx.bufnr })
        end,
      }

      vim.keymap.set('n', '<leader>ha', function()
        harpoon:list():add()
      end)
      vim.keymap.set('n', '<leader>hc', function()
        harpoon:list():clear()
      end)
      vim.keymap.set('n', '<leader>hh', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end)

      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set('n', '<C-S-P>', function()
        harpoon:list():prev()
      end)
      vim.keymap.set('n', '<C-S-N>', function()
        harpoon:list():next()
      end)
    end,
  },

  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  'tpope/vim-sleuth',
  'tpope/vim-eunuch',
  'tpope/vim-surround',

  { 'easymotion/vim-easymotion' },

  {
    'kawre/neotab.nvim',
    event = 'InsertEnter',
    opts = {
      tabkey = '<C-t>',
      act_as_tab = true,
      behavior = 'nested',
      pairs = {
        { open = '(', close = ')' },
        { open = '[', close = ']' },
        { open = '{', close = '}' },
        { open = "'", close = "'" },
        { open = '"', close = '"' },
        { open = '`', close = '`' },
        { open = '<', close = '>' },
      },
      exclude = {},
      smart_punctuators = {
        enabled = false,
        semicolon = {
          enabled = false,
          ft = { 'cs', 'c', 'cpp', 'java' },
        },
        escape = {
          enabled = false,
          triggers = {},
        },
      },
    },
  },

  {
    'dhruvasagar/vim-prosession',
    dependencies = {
      'tpope/vim-obsession',
    },
  },

  {
    'zirrostig/vim-schlepp',
    keys = { { '<Plug>SchleppUp', mode = 'v' }, { '<Plug>SchleppDown', mode = 'v' } },
  },

  {
    'sudo-tee/opencode.nvim',
    config = function()
      require('opencode').setup {}
    end,
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          anti_conceal = { enabled = false },
          file_types = { 'markdown', 'opencode_output' },
        },
        ft = { 'markdown', 'Avante', 'copilot-chat', 'opencode_output' },
      },
    },
  },
}
