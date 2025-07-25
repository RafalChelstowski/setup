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

  'christoomey/vim-tmux-navigator',

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
    'olimorris/codecompanion.nvim',
    cmd = { 'CodeCompanion', 'CodeCompanionChat', 'CodeCompanionToggle', 'CodeCompanionActions' },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'stevearc/dressing.nvim', -- Optional: Improves UI
      {
        'ravitemer/mcphub.nvim', -- Manage MCP servers
        cmd = 'MCPHub',
        build = 'npm install -g mcp-hub@latest',
        config = true,
      },
      {
        'Davidyz/VectorCode', -- Index and search code in your repositories
        version = '*',
        dependencies = { 'nvim-lua/plenary.nvim' },
        build = 'uv tool upgrade vectorcode',
        cmd = 'VectorCode',
      },
    },
    opts = {
      strategies = {
        chat = {
          adapter = 'openai',
          slash_commands = {
            ['buffer'] = {
              keymaps = {
                modes = {
                  i = '<C-b>',
                },
              },
            },
          },
        },
        inline = { adapter = 'openai' },
        agent = { adapter = 'openai' },
      },
      adapters = {
        openai = function()
          return require('codecompanion.adapters').extend('openai', {
            opts = {
              stream = false,
            },
            env = {
              api_key = 'OPENAI_API_KEY',
            },
            schema = {
              model = {
                default = function()
                  return 'gpt-4o-mini'
                end,
              },
            },
          })
        end,
        ollama = function()
          return require('codecompanion.adapters').extend('ollama', {
            schema = {
              model = {
                default = 'qwen3:14b',
              },
              num_ctx = {
                default = 16384,
              },
            },
          })
        end,
        deepseek = function()
          return require('codecompanion.adapters').extend('deepseek', {
            env = {
              api_key = 'DEEPSEEK_API_KEY',
            },
            schema = {
              model = {
                default = 'deepseek-chat',
              },
              num_ctx = {
                default = 16384,
              },
            },
          })
        end,
      },
      extensions = {
        mcphub = {
          callback = 'mcphub.extensions.codecompanion',
          opts = {
            make_vars = true,
            make_slash_commands = true,
            show_result_in_chat = true,
          },
        },
        vectorcode = {
          opts = {
            add_tool = true, -- Enable VectorCode as a tool
            add_slash_command = true, -- Enable /vectorcode slash command
          },
          tool_opts = {
            max_num = 5,
            default_num = 3,
          },
        },
      },
      display = {
        chat = {
          window = {
            width = 0.35,
          },
          auto_scroll = false,
          start_in_insert_mode = true,
        },
      },
      prompt_library = {
        ['Guide'] = {
          strategy = 'chat',
          description = 'Guide through solution',
          opts = {
            ignore_system_prompt = true,
          },
          prompts = {
            {
              role = 'system',
              content = [[
Context: You are a seasoned software developer with deep expertise in JavaScript, TypeScript, React, and modern front-end frameworks. Your task is to guide users through problem-solving processes without directly providing code. Instead, focus on explaining concepts, architecture decisions, and best practices, while directing users to official documentation for implementation details.

Objective: Help users understand how to achieve a specific front-end development goal by outlining steps, design considerations, and resource links, without sharing code snippets or solutions.

Style: Professional, technical, and instructive. Use language that mirrors a senior developer's thought process, emphasizing principles over implementation.

Tone: Authoritative yet collaborative, focusing on empowering the user to think critically and independently.

Audience: Experienced developers familiar with JavaScript/TypeScript ecosystems who seek conceptual guidance rather than quick fixes.

Response: Provide structured outputs such as step-by-step workflows, conceptual diagrams (described in text), and curated documentation links (e.g., MDN, React Docs, TypeScript Handbook).

Workflow:
1. **Identify the problem**: Clarify the user’s goal, constraints, and context.
2. **Breakdown**: Decompose the problem into architectural or technical subtasks.
3. **Guidance**: Explain design patterns, trade-offs, and key decisions for each subtask.
4. **Resources**: Share links to relevant documentation, tutorials, or community discussions.

Examples:
**Input**: "How to implement a responsive navigation bar in React with TypeScript?"
**Output**:
1. **Conceptual Approach**:
   - Use CSS Flexbox/Grid for layout adaptability.
   - Leverage React state to manage open/close toggles.
   - Apply TypeScript interfaces for component props and state.
2. **Implementation Guidance**:
   - Define a `NavigationProps` interface for component props.
   - Use `useState` to track the mobile menu’s visibility.
   - Employ media queries in CSS for responsive behavior.
3. **Resources**:
   - [React Official Docs: State](https://reactjs.org/docs/hooks-state.html)
   - [MDN: CSS Flexbox Guide](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Flexible_Box_Layout)
   - [TypeScript Handbook: Interfaces](https://www.typescriptlang.org/docs/handbook/interfaces.html)
                        ]],
            },
            {
              role = 'user',
              content = 'Guide me to solve a following problem:',
            },
          },
        },
      },
    },
  },
}
