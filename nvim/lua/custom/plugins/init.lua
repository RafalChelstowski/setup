-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  'romainl/vim-qf',
  {
    'christoomey/vim-tmux-navigator',
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
      'TmuxNavigatePrevious',
      'TmuxNavigatorProcessList',
    },
    keys = {
      { '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>' },
      { '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>' },
      { '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>' },
      { '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>' },
      { '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>' },
    },
  },

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
      update_interval = 3000,
      set_dark_mode = function()
        vim.api.nvim_set_option_value('background', 'dark', {})
        vim.cmd 'colorscheme base16-3024'
      end,
      set_light_mode = function()
        vim.api.nvim_set_option_value('background', 'light', {})
        vim.cmd 'colorscheme base16-tomorrow'
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

      vim.keymap.set('n', '<leader>hh', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = '[H]arpoon menu' })
      vim.keymap.set('n', '<leader>ha', function()
        harpoon:list():add()
      end, { desc = '[A]dd file to Harpoon' })
      vim.keymap.set('n', '<leader>hc', function()
        harpoon:list():clear()
      end, { desc = '[C]lear all Harpoon marks' })
      vim.keymap.set('n', '<leader>hn', function()
        harpoon:list():next()
      end, { desc = '[N]ext Harpoon file' })
      vim.keymap.set('n', '<leader>hp', function()
        harpoon:list():prev()
      end, { desc = '[P]rev Harpoon file' })

      -- Direct file access
      vim.keymap.set('n', '<leader>h1', function()
        harpoon:list():select(1)
      end, { desc = 'Harpoon file [1]' })
      vim.keymap.set('n', '<leader>h2', function()
        harpoon:list():select(2)
      end, { desc = 'Harpoon file [2]' })
      vim.keymap.set('n', '<leader>h3', function()
        harpoon:list():select(3)
      end, { desc = 'Harpoon file [3]' })
      vim.keymap.set('n', '<leader>h4', function()
        harpoon:list():select(4)
      end, { desc = 'Harpoon file [4]' })

      -- Telescope integration
      local conf = require('telescope.config').values
      local function toggle_telescope(harpoon_files)
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_paths, item.value)
        end

        require('telescope.pickers')
          .new({}, {
            prompt_title = 'Harpoon',
            finder = require('telescope.finders').new_table {
              results = file_paths,
            },
            previewer = conf.file_previewer {},
            sorter = conf.generic_sorter {},
          })
          :find()
      end

      vim.keymap.set('n', '<leader>ht', function()
        toggle_telescope(harpoon:list())
      end, { desc = '[T]elescope Harpoon' })
    end,
  },

  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  'tpope/vim-sleuth',
  'tpope/vim-eunuch',
  'tpope/vim-surround',

  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {},
    keys = {
      {
        'gs',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'Flash',
      },
      {
        'gS',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').treesitter()
        end,
        desc = 'Flash Treesitter',
      },
    },
  },

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

  -- Trouble: better diagnostics/quickfix list
  {
    'folke/trouble.nvim',
    cmd = 'Trouble',
    opts = {},
    keys = {
      { '<leader>dd', '<cmd>Trouble diagnostics toggle<cr>', desc = '[D]iagnostics (Trouble)' },
      { '<leader>dD', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer [D]iagnostics (Trouble)' },
      { '<leader>dq', '<cmd>Trouble qflist toggle<cr>', desc = '[Q]uickfix List (Trouble)' },
      { '<leader>dl', '<cmd>Trouble loclist toggle<cr>', desc = '[L]ocation List (Trouble)' },
    },
  },

  -- Oil: edit filesystem like a buffer
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('oil').setup {
        view_options = {
          show_hidden = true,
        },
        keymaps = {
          ['<C-h>'] = false, -- preserve window navigation
          ['<C-l>'] = false, -- preserve window navigation
        },
      }
      vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
    end,
  },

  -- Undotree: visualize undo history
  {
    'mbbill/undotree',
    keys = {
      { '<leader>tu', vim.cmd.UndotreeToggle, desc = '[T]oggle [U]ndotree' },
    },
  },

  -- Auto close/rename HTML tags
  {
    'windwp/nvim-ts-autotag',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {},
  },

  -- Git conflict resolution
  {
    'akinsho/git-conflict.nvim',
    version = '*',
    config = true,
  },

  -- Compile mode: project-wide error checking
  {
    'ej-shafran/compile-mode.nvim',
    version = '^5.0.0',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'm00qek/baleia.nvim', tag = 'v1.3.0' }, -- ANSI color support
    },
    cmd = { 'Compile', 'Recompile', 'CompileInterrupt' },
    keys = {
      { '<leader>dc', '<cmd>Compile<cr>', desc = '[C]ompile' },
      { '<leader>dr', '<cmd>Recompile<cr>', desc = '[R]ecompile' },
      { '<leader>di', '<cmd>CompileInterrupt<cr>', desc = '[I]nterrupt compilation' },
    },
    config = function()
      ---@type CompileModeOpts
      vim.g.compile_mode = {
        input_word_completion = true, -- fix tab completion (for blink-cmp)
        baleia_setup = true, -- enable ANSI colors
      }

      -- Function to extract file paths from compilation buffer and send to quickfix
      local function send_compile_files_to_quickfix()
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local qf_entries = {}
        local current_file = nil -- Track current file for ESLint stylish format

        for _, line in ipairs(lines) do
          local filepath, lnum, col, msg

          -- Pattern 1: TypeScript format with error message
          -- Matches: src/store/app-slice.ts:180:7 - error TS2722: Cannot invoke...
          filepath, lnum, col, msg = line:match '^([%w%._/-]+%.%w+):(%d+):(%d+)%s+%-%s+%w+%s+%w+:%s*(.+)$'

          if not filepath then
            -- Pattern 2: TypeScript format without message (just path:line:col)
            filepath, lnum, col = line:match '^([%w%._/-]+%.%w+):(%d+):(%d+)'
          end

          if not filepath then
            -- Pattern 3: path(line,col) format (alternative TypeScript format)
            filepath, lnum, col = line:match '([%w%._/-]+%.%w+)%((%d+),(%d+)%)'
          end

          if not filepath then
            -- Pattern 4: Standalone absolute path line (ESLint stylish file header)
            -- Matches: /Users/user/project/src/file.tsx
            local standalone_path = line:match '^(/[^%s:%(]+%.%w+)%s*$'
            if standalone_path then
              current_file = standalone_path
              filepath = nil -- Don't create entry yet, wait for error lines
            end
          end

          if not filepath and current_file then
            -- Pattern 5: ESLint stylish format - indented line:col  severity  message
            -- Matches:   38:6  warning  React Hook useEffect has a missing dependency
            lnum, col, msg = line:match '^%s+(%d+):(%d+)%s+%w+%s+(.+)$'
            if lnum then
              filepath = current_file
            end
          end

          -- Reset current_file if we hit an empty line (end of ESLint file section)
          if line:match '^%s*$' then
            current_file = nil
          end

          if filepath then
            table.insert(qf_entries, {
              filename = filepath,
              lnum = tonumber(lnum) or 1,
              col = tonumber(col) or 1,
              text = msg or 'error',
            })
          end
        end

        if #qf_entries == 0 then
          vim.notify('No file paths found in compilation buffer', vim.log.levels.WARN)
          return
        end

        vim.fn.setqflist(qf_entries, 'r')
        vim.notify(string.format('Added %d errors to quickfix', #qf_entries), vim.log.levels.INFO)
        vim.cmd 'Trouble qflist'
      end

      -- Create autocmd to add keybinding only in compilation buffers
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'compilation',
        callback = function(ev)
          vim.keymap.set('n', '<leader>df', send_compile_files_to_quickfix, {
            buffer = ev.buf,
            desc = 'Send compile [F]iles to quickfix/Trouble',
          })
        end,
      })
    end,
  },

  -- Refactoring: ThePrimeagen's refactoring library
  {
    'ThePrimeagen/refactoring.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    lazy = false,
    config = function()
      require('refactoring').setup {
        show_success_message = true,
      }

      -- Load Telescope extension
      require('telescope').load_extension 'refactoring'

      -- Refactor menu (Telescope)
      vim.keymap.set({ 'n', 'x' }, '<leader>rr', function()
        require('telescope').extensions.refactoring.refactors()
      end, { desc = '[R]efactor menu' })

      -- Extract operations (visual mode)
      vim.keymap.set('x', '<leader>re', function()
        require('refactoring').refactor 'Extract Function'
      end, { desc = '[E]xtract function' })

      vim.keymap.set('x', '<leader>rf', function()
        require('refactoring').refactor 'Extract Function To File'
      end, { desc = 'Extract function to [F]ile' })

      vim.keymap.set('x', '<leader>rv', function()
        require('refactoring').refactor 'Extract Variable'
      end, { desc = 'Extract [V]ariable' })

      -- Inline operations
      vim.keymap.set({ 'n', 'x' }, '<leader>ri', function()
        require('refactoring').refactor 'Inline Variable'
      end, { desc = '[I]nline variable' })

      vim.keymap.set('n', '<leader>rI', function()
        require('refactoring').refactor 'Inline Function'
      end, { desc = '[I]nline function' })

      -- Block operations (normal mode)
      vim.keymap.set('n', '<leader>rb', function()
        require('refactoring').refactor 'Extract Block'
      end, { desc = 'Extract [B]lock' })

      vim.keymap.set('n', '<leader>rB', function()
        require('refactoring').refactor 'Extract Block To File'
      end, { desc = 'Extract [B]lock to file' })

      -- Debug operations
      vim.keymap.set('n', '<leader>rp', function()
        require('refactoring').debug.printf { below = false }
      end, { desc = '[P]rintf debug' })

      vim.keymap.set({ 'n', 'x' }, '<leader>rd', function()
        require('refactoring').debug.print_var()
      end, { desc = 'Print var [D]ebug' })

      vim.keymap.set('n', '<leader>rc', function()
        require('refactoring').debug.cleanup {}
      end, { desc = '[C]leanup debug prints' })
    end,
  },

  -- nvim-dap: Debug Adapter Protocol
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      -- UI for nvim-dap
      {
        'rcarriga/nvim-dap-ui',
        dependencies = { 'nvim-neotest/nvim-nio' },
        config = function()
          local dap, dapui = require 'dap', require 'dapui'
          dapui.setup()
          dap.listeners.after.event_initialized['dapui_config'] = function()
            dapui.open()
          end
          dap.listeners.before.event_terminated['dapui_config'] = function()
            dapui.close()
          end
          dap.listeners.before.event_exited['dapui_config'] = function()
            dapui.close()
          end
        end,
      },
      -- Virtual text for nvim-dap
      { 'theHamsta/nvim-dap-virtual-text', opts = {} },
      -- Mason integration for installing debug adapters
      { 'jay-babu/mason-nvim-dap.nvim' },
    },
    config = function()
      local dap = require 'dap'

      -- JS/TS debugging with js-debug-adapter
      require('mason-nvim-dap').setup {
        ensure_installed = { 'js', 'python' },
        automatic_installation = true,
      }

      -- JavaScript/TypeScript configuration
      for _, adapter in ipairs { 'pwa-node', 'pwa-chrome' } do
        dap.adapters[adapter] = {
          type = 'server',
          host = 'localhost',
          port = '${port}',
          executable = {
            command = 'node',
            args = {
              vim.fn.stdpath 'data' .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js',
              '${port}',
            },
          },
        }
      end

      for _, language in ipairs { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' } do
        dap.configurations[language] = {
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Launch file',
            program = '${file}',
            cwd = '${workspaceFolder}',
          },
          {
            type = 'pwa-node',
            request = 'attach',
            name = 'Attach',
            processId = require('dap.utils').pick_process,
            cwd = '${workspaceFolder}',
          },
          {
            type = 'pwa-chrome',
            request = 'launch',
            name = 'Launch Chrome',
            url = 'http://localhost:3000',
            webRoot = '${workspaceFolder}',
          },
        }
      end

      -- Python configuration (handled by mason-nvim-dap)
    end,
  },

  -- Neotest: Test runner framework
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      -- Adapters
      'nvim-neotest/neotest-jest',
      'marilari88/neotest-vitest',
      'nvim-neotest/neotest-python',
      'thenbe/neotest-playwright',

      'nvim-neotest/neotest-vim-test',
      -- vim-test for fallback (Cypress, etc.)
      'vim-test/vim-test',
    },
    config = function()
      require('neotest').setup {
        adapters = {
          require 'neotest-jest' {
            jestCommand = 'yarn test',
            jestConfigFile = function()
              -- Auto-detect jest config (using vim.uv for async-safe operations)
              local cwd = vim.uv.cwd()
              local function file_exists(path)
                local stat = vim.uv.fs_stat(path)
                return stat and stat.type == 'file'
              end
              if file_exists(cwd .. '/jest.config.ts') then
                return cwd .. '/jest.config.ts'
              elseif file_exists(cwd .. '/jest.config.js') then
                return cwd .. '/jest.config.js'
              elseif file_exists(cwd .. '/jest.config.mjs') then
                return cwd .. '/jest.config.mjs'
              end
              return nil
            end,
            env = { CI = true },
            cwd = function()
              return vim.uv.cwd()
            end,
          },
          require 'neotest-vitest',
          require 'neotest-python' {
            dap = { justMyCode = false },
            runner = 'pytest',
          },
          require('neotest-playwright').adapter {
            options = {
              persist_project_selection = true,
              enable_dynamic_test_discovery = true,
            },
          },

          require 'neotest-vim-test' {
            ignore_file_types = { 'python', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
          },
        },
        status = { virtual_text = true },
        output = { open_on_run = true },
        quickfix = {
          open = function()
            vim.cmd 'Trouble quickfix'
          end,
        },
      }

      -- Keybindings
      vim.keymap.set('n', '<leader>nn', function()
        require('neotest').run.run()
      end, { desc = 'Run [N]earest test' })

      vim.keymap.set('n', '<leader>nf', function()
        require('neotest').run.run(vim.fn.expand '%')
      end, { desc = 'Run [F]ile tests' })

      vim.keymap.set('n', '<leader>ns', function()
        require('neotest').run.run { suite = true }
      end, { desc = 'Run [S]uite' })

      vim.keymap.set('n', '<leader>nl', function()
        require('neotest').run.run_last()
      end, { desc = 'Run [L]ast test' })

      vim.keymap.set('n', '<leader>nd', function()
        require('neotest').run.run { strategy = 'dap' }
      end, { desc = '[D]ebug nearest test' })

      vim.keymap.set('n', '<leader>nD', function()
        require('neotest').run.run { vim.fn.expand '%', strategy = 'dap' }
      end, { desc = '[D]ebug file tests' })

      vim.keymap.set('n', '<leader>no', function()
        require('neotest').output.open { enter = true, auto_close = true }
      end, { desc = 'Show [O]utput' })

      vim.keymap.set('n', '<leader>nO', function()
        require('neotest').output_panel.toggle()
      end, { desc = 'Toggle [O]utput panel' })

      vim.keymap.set('n', '<leader>np', function()
        require('neotest').summary.toggle()
      end, { desc = 'Toggle summary [P]anel' })

      vim.keymap.set('n', '<leader>nw', function()
        require('neotest').watch.toggle(vim.fn.expand '%')
      end, { desc = 'Toggle [W]atch mode' })

      vim.keymap.set('n', '<leader>nx', function()
        require('neotest').run.stop()
      end, { desc = 'Stop test' })

      vim.keymap.set('n', '<leader>na', function()
        require('neotest').run.attach()
      end, { desc = '[A]ttach to test' })

      -- Session storage for custom test command (no file modification)
      local custom_test_cmd = nil

      vim.keymap.set('n', '<leader>nc', function()
        -- Prompt with last command as default (or 'yarn test --' if first time)
        local default_cmd = custom_test_cmd or 'yarn test --'
        local cmd = vim.fn.input('Test command: ', default_cmd)
        if cmd and cmd ~= '' then
          custom_test_cmd = cmd -- Remember for next time
          require('neotest').run.run {
            extra_args = { '--config', 'jest.config.js' },
            jestCommand = cmd,
          }
        end
      end, { desc = 'Run nearest with [C]ustom command' })

      vim.keymap.set('n', '<leader>nC', function()
        -- Prompt with last command as default
        local default_cmd = custom_test_cmd or 'yarn test --'
        local cmd = vim.fn.input('Test command: ', default_cmd)
        if cmd and cmd ~= '' then
          custom_test_cmd = cmd -- Remember for next time
          require('neotest').run.run {
            vim.fn.expand '%',
            jestCommand = cmd,
          }
        end
      end, { desc = 'Run file with [C]ustom command' })
    end,
  },
  {
    'ThePrimeagen/99',
    config = function()
      local _99 = require '99'

      -- For logging that is to a file if you wish to trace through requests
      -- for reporting bugs, i would not rely on this, but instead the provided
      -- logging mechanisms within 99.  This is for more debugging purposes
      local cwd = vim.uv.cwd()
      local basename = vim.fs.basename(cwd)
       _99.setup {
         logger = {
           level = _99.DEBUG,
           path = '/tmp/' .. basename .. '.99.debug',
           print_on_error = true,
         },
         model = "opencode/grok-code",

         --- WARNING: if you change cwd then this is likely broken
         --- ill likely fix this in a later change
         ---
         --- md_files is a list of files to look for and auto add based on the location
         --- of the originating request.  That means if you are at /foo/bar/baz.lua
         --- the system will automagically look for:
         --- /foo/bar/AGENT.md
         --- /foo/AGENT.md
         --- assuming that /foo is project root (based on cwd)
         md_files = {
           'AGENT.md',
         },
       }

      -- Create your own short cuts for the different types of actions
      vim.keymap.set('n', '<leader>9f', function()
        _99.fill_in_function()
      end, { desc = '[9]9 Fill in function' })
      -- take extra note that i have visual selection only in v mode
      -- technically whatever your last visual selection is, will be used
      -- so i have this set to visual mode so i dont screw up and use an
      -- old visual selection
      --
      -- likely ill add a mode check and assert on required visual mode
      -- so just prepare for it now
      vim.keymap.set('v', '<leader>9v', function()
        _99.visual()
      end, { desc = '[9]9 Visual selection' })

      vim.keymap.set('v', '<leader>9a', function()
        _99.visual_prompt()
      end, { desc = '[9]9 Visual prompt' })

      --- if you have a request you dont want to make any changes, just cancel it
      vim.keymap.set('v', '<leader>9s', function()
        _99.stop_all_requests()
      end, { desc = '[9]9 Stop requests' })
    end,
  },
}
