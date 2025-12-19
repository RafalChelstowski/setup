# Keybindings Reference

## Tmux (`prefix` = Ctrl+A)

### Session & Window Management

| Key | Action |
|-----|--------|
| `Ctrl+F` | Sesh session picker (fzf) |
| `prefix+s` | Session tree |
| `prefix+L` | Last session (sesh) |
| `prefix+y` | Open vifm (fast file manager) |
| `prefix+Y` | Open MC (full-featured file manager) |
| `prefix+g` | Open lazygit |
| `prefix+j` | Split pane right (35%) |
| `prefix+J` | Split pane right with opencode |
| `prefix+u` | New window with 50/50 split |
| `prefix+x` | Kill pane |
| `prefix+X` | Kill window |
| `prefix+o` | Kill other panes |

### Sesh Picker (`Ctrl+F`)

| Key | Action |
|-----|--------|
| `Ctrl+A` | All sessions |
| `Ctrl+T` | Tmux sessions only |
| `Ctrl+G` | Config sessions |
| `Ctrl+X` | Zoxide directories |
| `Ctrl+F` | Find directories |
| `Ctrl+D` | Kill selected session |

### Utilities

| Key | Action |
|-----|--------|
| `prefix+F` | tmux-thumbs (pattern hints → clipboard) |
| `prefix+Tab` | extrakto (fzf text search → clipboard) |
| `Ctrl+D` | Show pane/window count (in zsh only) |

### Copy Mode (vi)

| Key | Action |
|-----|--------|
| `v` | Begin selection |
| `V` | Select line |
| `y` | Copy to clipboard |

---

## Neovim

### Navigation

| Key | Mode | Action |
|-----|------|--------|
| `<C-h/j/k/l>` | n | Move focus between windows (tmux-aware) |
| `-` | n | Open Oil (parent directory) |
| `gs` | n,x,o | Flash jump |
| `gS` | n,x,o | Flash treesitter select |

### Buffer (`<leader>b`)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>bb` | n | Buffer picker (Telescope) |
| `<leader>bd` | n | Delete buffer (prompt if unsaved) |
| `<leader>bD` | n | Delete buffer (force) |
| `<leader>bo` | n | Delete other buffers |
| `<leader>ba` | n | Delete all buffers |
| `<leader>bx` | n | Scratch buffer |
| `<leader>bm` | n | Markdown scratch buffer |

### Macros (`<leader>m`)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>mq` | n | Toggle macro recording (register q) |
| `<leader>mr` | n | Run macro (register q) |
| `<leader>mR` | n | Run macro (prompt for register) |
| `<leader>me` | n | Edit macro (register q) in scratch buffer |
| `<leader>ml` | n | List registers (Telescope) |
| `<leader>mp` | v | Play macro (q) on each selected line |

**Workflow example:**
1. `<leader>mq` - Start recording
2. Make your edits
3. `<leader>mq` - Stop recording
4. `<leader>mr` - Replay the macro
5. `<leader>me` - Edit if you made a mistake

### Refactor (`<leader>r`)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>rr` | n,x | Refactor menu (Telescope picker) |
| `<leader>re` | x | Extract function |
| `<leader>rf` | x | Extract function to file |
| `<leader>rv` | x | Extract variable |
| `<leader>ri` | n,x | Inline variable |
| `<leader>rI` | n | Inline function |
| `<leader>rb` | n | Extract block |
| `<leader>rB` | n | Extract block to file |
| `<leader>rp` | n | Printf debug statement |
| `<leader>rd` | n,x | Print variable debug |
| `<leader>rc` | n | Cleanup debug prints |

**Supported languages:** TypeScript, JavaScript, Lua, C/C++, Go, Python, Java, PHP, Ruby, C#

**Workflow example (extract function):**
1. Select code in visual mode
2. `<leader>re` - Extract to function
3. Enter function name when prompted

### Neotest (`<leader>n`)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>nn` | n | Run nearest test |
| `<leader>nf` | n | Run file tests |
| `<leader>ns` | n | Run test suite |
| `<leader>nl` | n | Run last test |
| `<leader>nd` | n | Debug nearest test |
| `<leader>nD` | n | Debug file tests |
| `<leader>no` | n | Show test output |
| `<leader>nO` | n | Toggle output panel |
| `<leader>np` | n | Toggle summary panel |
| `<leader>nw` | n | Toggle watch mode |
| `<leader>nx` | n | Stop running test |
| `<leader>na` | n | Attach to running test |
| `<leader>nc` | n | Run nearest with custom command (prompts) |
| `<leader>nC` | n | Run file with custom command (prompts) |

**Summary Panel Keys (`<leader>np`):**

| Key | Action |
|-----|--------|
| `r` | Run test under cursor |
| `d` | Debug test under cursor |
| `o` | Show output |
| `O` | Show short output |
| `i` | Jump to test file |
| `a` | Attach to running test |
| `u` | Stop test |
| `w` | Toggle watch mode |
| `<CR>` | Expand/collapse |
| `e` | Expand all |
| `P` | Go to parent |
| `J` | Next failed test |
| `K` | Previous failed test |
| `m` | Mark test |
| `R` | Run all marked |
| `D` | Debug all marked |
| `M` | Clear all marks |
| `?` | Show help |

**Supported test runners:**
- Jest (`neotest-jest`)
- Vitest (`neotest-vitest`)
- Pytest (`neotest-python`)
- Playwright (`neotest-playwright`)
- Others via `vim-test` fallback (Cypress, etc.)

**Workflow example:**
1. Open a test file
2. `<leader>nn` - Run test under cursor
3. `<leader>no` - See output if failed
4. `<leader>nw` - Enable watch mode for TDD

### Harpoon (`<leader>h`)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>hh` | n | Toggle harpoon menu |
| `<leader>ha` | n | Add file to harpoon |
| `<leader>hc` | n | Clear all harpoon marks |
| `<leader>hn` | n | Next harpoon file |
| `<leader>hp` | n | Previous harpoon file |
| `<leader>h1` | n | Jump to harpoon file 1 |
| `<leader>h2` | n | Jump to harpoon file 2 |
| `<leader>h3` | n | Jump to harpoon file 3 |
| `<leader>h4` | n | Jump to harpoon file 4 |
| `<leader>ht` | n | Telescope harpoon picker |

**In harpoon menu:**
| Key | Action |
|-----|--------|
| `<C-v>` | Open in vertical split |
| `<C-x>` | Open in horizontal split |
| `<C-t>` | Open in new tab |

### Diagnostics (`<leader>d`)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>dd` | n | Toggle all diagnostics (Trouble) |
| `<leader>dD` | n | Buffer diagnostics only (Trouble) |
| `<leader>dq` | n | Quickfix list (Trouble) |
| `<leader>dl` | n | Location list (Trouble) |
| `<leader>dc` | n | Compile (prompt for command) |
| `<leader>dr` | n | Recompile (run last command) |
| `<leader>di` | n | Interrupt compilation |
| `<leader>df` | n | Send compile files to quickfix (in compilation buffer) |
| `<leader>dn` | n | Next diagnostic |
| `<leader>dp` | n | Previous diagnostic |
| `<leader>de` | n | Open floating diagnostic |
| `[d` / `]d` | n | Previous/next diagnostic (vim-style alias) |

#### Compile Mode Usage

Common commands to run with `:Compile` or `<leader>dc`:

| Command | Use case |
|---------|----------|
| `yarn typecheck` | TypeScript type check |
| `yarn lint` | ESLint |
| `yarn build` | Vite/Next.js build |
| `cargo check` | Rust |
| `mypy .` | Python type check |

In compilation buffer:
- `<CR>` — jump to error location (if recognized by compile-mode)
- `<leader>df` — extract ALL errors with file:line:col + message → Trouble
- `q` — close buffer

**Recommended workflow:**
1. Run compile (`<leader>dc`) → e.g., `yarn typecheck` or `yarn lint`
2. Press `<leader>df` to extract all errors to quickfix with messages
3. Navigate errors in Trouble (click or `<CR>` to jump)
4. Fix errors, then `<leader>dr` to recompile

**Supported formats:**
- TypeScript: `src/file.ts:10:5 - error TS2304: message`
- ESLint stylish: `/path/file.tsx` + indented `10:5  error  message`

### Treesitter Text Objects

| Key | Mode | Action |
|-----|------|--------|
| `af` / `if` | o,x | Around/inside function |
| `ac` / `ic` | o,x | Around/inside class |
| `aa` / `ia` | o,x | Around/inside argument |
| `]m` / `[m` | n | Next/previous function start |
| `]M` / `[M` | n | Next/previous function end |
| `]]` / `[[` | n | Next/previous class start |
| `][` / `[]` | n | Next/previous class end |
| `<leader>a` | n | Swap argument with next |
| `<leader>A` | n | Swap argument with previous |

### Copy to Clipboard (`<leader>c`)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>cf` | n | Copy filename |
| `<leader>cr` | n | Copy relative path |
| `<leader>cp` | n | Copy full path |
| `<leader>cw` | n | Copy working directory |
| `<leader>cl` | n | Copy line reference (file:line) |
| `<leader>cd` | n | Copy diagnostic (current line) |
| `<leader>cD` | n | Copy diagnostic with context (for LLM) |
| `<leader>ca` | n | Copy all diagnostics in buffer |

#### Copy Diagnostic for LLM (`<leader>cD`)

Copies diagnostic with file path, error message, and 3 lines of context above/below:

```
File: src/components/Button.tsx:42:5
error: Cannot find name 'foo'. [ts2304] (typescript)

Context:
```typescript
      39 | const handleClick = () => {
      40 |   console.log('clicked');
 -->  41 |   foo.bar();
      42 | };
      43 |
```
```

### Git (`<leader>g`)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>gs` | n,v | Stage hunk |
| `<leader>gr` | n,v | Reset hunk |
| `<leader>gS` | n | Stage buffer |
| `<leader>gR` | n | Reset buffer |
| `<leader>gu` | n | Undo stage hunk |
| `<leader>gp` | n | Preview hunk |
| `<leader>gb` | n | Blame line |
| `<leader>gd` | n | Diff against index |
| `<leader>gD` | n | Diff against last commit |
| `]c` / `[c` | n | Next/previous hunk |

#### Git Conflicts (in conflicted files)

| Key | Mode | Action |
|-----|------|--------|
| `co` | n | Choose ours (current) |
| `ct` | n | Choose theirs (incoming) |
| `cb` | n | Choose both |
| `c0` | n | Choose none |
| `]x` / `[x` | n | Next/previous conflict |

### Search (Telescope) (`<leader>s`)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>sf` | n | Find files |
| `<leader>sg` | n | Live grep |
| `<leader>sw` | n | Search current word |
| `<leader>sb` | n | Search buffers |
| `<leader>sh` | n | Search help |
| `<leader>sk` | n | Search keymaps |
| `<leader>ss` | n | Search select (Telescope pickers) |
| `<leader>sd` | n | Search diagnostics |
| `<leader>sr` | n | Resume last search |
| `<leader>sn` | n | Search Neovim config files |
| `<leader>s.` | n | Recent files |
| `<leader>s/` | n | Live grep in open files |
| `<leader>/` | n | Fuzzy search current buffer |

### LSP Actions (`<leader>l`)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>la` | n,x | Code action |
| `<leader>lr` | n | Rename symbol |
| `<leader>lh` | n | Toggle inlay hints |
| `<leader>ls` | n | Restart LSP |
| `<leader>li` | n | LSP info |

### LSP Navigation (`g*`)

| Key | Mode | Action |
|-----|------|--------|
| `gd` | n | Go to definition |
| `gD` | n | Go to declaration |
| `gr` | n | Go to references |
| `gi` | n | Go to implementation |
| `gt` | n | Go to type definition |
| `gO` | n | Document symbols |
| `gW` | n | Workspace symbols |
| `K` | n | Hover documentation |

### Snippets (LuaSnip)

| Key | Mode | Action |
|-----|------|--------|
| `<C-j>` | i,s | Jump to next snippet placeholder |
| `<C-k>` | i,s | Jump to previous snippet placeholder |

### Visual Mode

| Key | Mode | Action |
|-----|------|--------|
| `<C-j>` | v | Move selection down (Schlepp) |
| `<C-k>` | v | Move selection up (Schlepp) |

### Toggle (`<leader>t`)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>tb` | n | Toggle git blame line |
| `<leader>tD` | n | Toggle git deleted (preview inline) |
| `<leader>tu` | n | Toggle Undotree |

### Project/Files (`<leader>p`)

| Key | Mode | Action |
|-----|------|--------|
| `<leader>pp` | n,v | Save and open Oil file browser |

### Other

| Key | Mode | Action |
|-----|------|--------|
| `<Esc>` | n | Clear search highlights |
| `<Esc><Esc>` | t | Exit terminal mode |
| `<C-t>` | i | Tab out of brackets (neotab) |

### Oil (file browser)

| Key | Mode | Action |
|-----|------|--------|
| `-` | n | Open parent directory |
| `<CR>` | n | Open file/directory |
| `g?` | n | Show help |
| `g.` | n | Toggle hidden files |

---

## vifm (Fast File Manager)

Open via `prefix+y` in tmux, or `vf` in shell (auto light/dark theme).

### Navigation

| Key | Action |
|-----|--------|
| `j` / `k` | Down / Up |
| `h` / `l` | Parent / Enter directory |
| `gg` / `G` | Top / Bottom |
| `Tab` | Switch panes |
| `Ctrl+H` / `Ctrl+L` | Move focus left/right pane |

### Bookmarks

| Key | Action |
|-----|--------|
| `'d` | Jump to ~/dev |
| `'s` | Jump to ~/dev/setup |
| `'c` | Jump to ~/.config |
| `'h` | Jump to ~ |
| `'D` | Jump to ~/Downloads |
| `m<key>` | Set bookmark at current dir |

### File Operations

| Key | Action |
|-----|--------|
| `yy` | Yank (copy) file |
| `dd` | Delete file |
| `p` | Paste |
| `cw` | Rename |
| `af` | Create new file |
| `ad` | Create new directory |

### Useful Commands

| Key | Action |
|-----|--------|
| `w` | Toggle preview pane |
| `q` | Quit |
| `zh` | Toggle hidden files |
| `,s` | Open shell |
| `,f` | Open in Finder |
| `,g` | Open lazygit |
| `,z` | Zoxide jump (`:Z <query>`) |
| `yp` | Copy full path to clipboard |
| `yn` | Copy filename to clipboard |

### Commands

| Command | Action |
|---------|--------|
| `:Z <query>` | Zoxide jump |
| `:lg` | Open lazygit |
| `:finder` | Open in Finder |
| `:diff` | Diff selected files in nvim |

---

## Midnight Commander

Open via `prefix+Y` in tmux, or `mc` in shell (auto light/dark theme).

### Panel Navigation (vim keymap)

| Key | Action |
|-----|--------|
| `j` / `k` | Down / Up (in viewer) |
| `Shift+J` / `Shift+K` | Mark and move down/up |
| `Alt+J` | Enter child directory |
| `Alt+K` | Go to parent directory |
| `Tab` | Switch panels |
| `Home` / `End` | Top / Bottom of list |
| `{` / `}` | Page up / Page down |

### File Operations

| Key | Action |
|-----|--------|
| `F3` | View file |
| `F4` | Edit file (nvim) |
| `F5` | Copy |
| `F6` | Move/Rename |
| `F7` | Make directory |
| `F8` | Delete |
| `F10` or `Esc Esc` | Quit |

### Selection

| Key | Action |
|-----|--------|
| `Insert` or `Ctrl+T` | Toggle select file |
| `+` | Select by pattern |
| `-` | Unselect by pattern |
| `*` | Invert selection |

### Navigation & Search

| Key | Action |
|-----|--------|
| `Ctrl+S` or `Alt+S` | Quick search (type to filter) |
| `Alt+C` | Quick cd (type path) |
| `Ctrl+\` | Hotlist (bookmarks) |
| `Alt+.` | Toggle hidden files |
| `Ctrl+O` | Toggle shell (show terminal) |
| `Alt+H` | Directory history |

### Viewer (F3) - Vim-like

| Key | Action |
|-----|--------|
| `j` / `k` | Scroll down / up |
| `h` / `l` | Scroll left / right |
| `d` / `u` | Half page down / up |
| `f` / `b` | Full page down / up |
| `g` / `G` | Top / Bottom |
| `/` / `?` | Search forward / backward |
| `n` / `N` | Next / Previous match |
| `q` | Quit viewer |

### Extended Commands (`Ctrl+X` prefix)

| Key | Action |
|-----|--------|
| `Ctrl+X c` | Chmod |
| `Ctrl+X o` | Chown |
| `Ctrl+X l` | Create hard link |
| `Ctrl+X s` | Create symlink |
| `Ctrl+X i` | Panel info |
| `Ctrl+X q` | Quick view panel |
| `Ctrl+X h` | Add to hotlist |

---

## Dashboard (wtfutil + btm)

Opens automatically when connecting to sesh HOME session.

### Layout

```
┌─────────────────────────────────────────────┬──────────────────────────┐
│  wtfutil (65%)                              │  btm (35%)               │
│  ┌───────────────────────────────────────┐  │  CPU graph               │
│  │ Dev Servers                           │  │  Memory usage            │
│  │ Shows: yarn, npm, vite, esbuild, etc. │  │  Temperature sensors     │
│  └───────────────────────────────────────┘  │  Disk usage              │
│  ┌───────────────────────────────────────┐  │  Process list            │
│  │ Test Watchers                         │  │                          │
│  │ Shows: jest, vitest, playwright, etc. │  │                          │
│  └───────────────────────────────────────┘  │                          │
│  ┌───────────────────────────────────────┐  │                          │
│  │ LM Studio                             │  │                          │
│  │ Server status, loaded models          │  │                          │
│  └───────────────────────────────────────┘  │                          │
└─────────────────────────────────────────────┴──────────────────────────┘
```

### wtfutil Keys

| Key | Action |
|-----|--------|
| `1` | Focus Dev Servers widget |
| `2` | Focus Test Watchers widget |
| `3` | Focus LM Studio widget |
| `r` | Refresh focused widget |
| `/` | Open widget help |
| `q` | Quit wtfutil (shell remains) |

### btm Keys

| Key | Action |
|-----|--------|
| `h/j/k/l` | Navigate widgets |
| `gg` / `G` | Jump to top/bottom of process list |
| `/` | Search processes |
| `Tab` | Toggle process tree view |
| `e` | Expand selected widget |
| `q` | Quit btm (shell remains) |

### Pane Navigation (standard tmux)

| Key | Action |
|-----|--------|
| `prefix + arrow` | Switch between wtfutil and btm panes |
| `prefix + z` | Zoom current pane |

---

## Shell (zsh-vi-mode)

### Completion

| Key | Action |
|-----|--------|
| `Tab` | Standard completion |
| `Shift+Tab` | Completion menu |
| `Escape` | Cancel completion menu |
| `Ctrl+R` | Atuin history search |

### Directory Navigation

| Key | Action |
|-----|--------|
| `z <name>` | Zoxide jump to directory |
| `vf` | vifm file manager (auto light/dark) |
| `mc` | Midnight Commander (auto light/dark) |

---

## Troubleshooting & Notes

### Neotest Jest Configuration

**Issue: Tests pass but show as failed**

If tests run successfully but neotest marks them as failed, check your `jestCommand`:

```lua
-- WRONG: trailing -- breaks JSON output parsing
jestCommand = 'yarn test --',

-- CORRECT: no trailing --
jestCommand = 'yarn test',
```

The `--` causes Jest to treat neotest's flags (`--json`, `--outputFile`, etc.) as positional arguments instead of options.

**Issue: E5560 Vimscript function must not be called in a fast event context**

In neotest config functions (like `jestConfigFile` or `cwd`), use async-safe `vim.uv` instead of `vim.fn`:

```lua
-- WRONG: vim.fn is not async-safe
cwd = function()
  return vim.fn.getcwd()
end,

-- CORRECT: vim.uv is async-safe
cwd = function()
  return vim.uv.cwd()
end,

-- For file existence checks:
local function file_exists(path)
  local stat = vim.uv.fs_stat(path)
  return stat and stat.type == 'file'
end
```
