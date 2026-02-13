# Keybindings Reference

## Tmux (prefix = Ctrl+A)

### Session & Window Management

- `Ctrl+F` — Sesh session picker (fzf)
  - `Ctrl+A` — All sessions
  - `Ctrl+T` — Tmux sessions only
  - `Ctrl+W` — Windows (all sessions)
  - `Ctrl+G` — Config sessions
  - `Ctrl+X` — Zoxide directories
  - `Ctrl+F` — Find directories
  - `Ctrl+D` — Kill selected session
- `prefix+s` — Session tree
- `prefix+l/L` — Last session (sesh)
- `prefix+y` — Open vifm (fast file manager)
- `prefix+Y` — Open MC (full-featured file manager)
- `prefix+g` — Open lazygit
- `prefix+m` — Open markdown note picker (fzf → nvim)
- `prefix+j` — Split pane right (35%)
- `prefix+J` — Split pane right with opencode
- `prefix+u` — New window with 50/50 split
- `prefix+x` — Kill pane
- `prefix+X` — Kill window
- `prefix+o` — Kill other panes

### Utilities

- `prefix+F` — tmux-thumbs (pattern hints → clipboard)
- `prefix+Tab` — extrakto (fzf text search → clipboard)
- `Ctrl+D` — Show pane/window count (in zsh only)

### Copy Mode (vi)

- `v` — Begin selection
- `V` — Select line
- `y` — Copy to clipboard

---

## Neovim

### Navigation

- `<C-h/j/k/l>` — Move focus between windows (tmux-aware)
- `-` — Open Oil (parent directory)
- `gs` — Flash jump
- `gS` — Flash treesitter select

### Buffer (`<leader>b`)

- `<leader>bb` — Buffer picker (Telescope)
- `<leader>bd` — Delete buffer (prompt if unsaved)
- `<leader>bD` — Delete buffer (force)
- `<leader>bo` — Delete other buffers
- `<leader>ba` — Delete all buffers
- `<leader>bx` — Scratch buffer
- `<leader>bm` — Markdown scratch buffer

### Macros (`<leader>m`)

- `<leader>mq` — Toggle macro recording (register q)
- `<leader>mr` — Run macro (register q)
- `<leader>mR` — Run macro (prompt for register)
- `<leader>me` — Edit macro (register q) in scratch buffer
- `<leader>ml` — List registers (Telescope)
- `<leader>mp` [v] — Play macro (q) on each selected line

Workflow: `<leader>mq` → make edits → `<leader>mq` → `<leader>mr` to replay, `<leader>me` to edit.

### Refactor (`<leader>r`)

- `<leader>rr` — Refactor menu (Telescope picker)
- `<leader>re` [x] — Extract function
- `<leader>rf` [x] — Extract function to file
- `<leader>rv` [x] — Extract variable
- `<leader>ri` — Inline variable
- `<leader>rI` — Inline function
- `<leader>rb` — Extract block
- `<leader>rB` — Extract block to file
- `<leader>rp` — Printf debug statement
- `<leader>rd` — Print variable debug
- `<leader>rc` — Cleanup debug prints

Supports: TypeScript, JavaScript, Lua, C/C++, Go, Python, Java, PHP, Ruby, C#.

### Neotest (`<leader>n`)

- `<leader>nn` — Run nearest test
- `<leader>nf` — Run file tests
- `<leader>ns` — Run test suite
- `<leader>nl` — Run last test
- `<leader>nd` — Debug nearest test
- `<leader>nD` — Debug file tests
- `<leader>no` — Show test output
- `<leader>nO` — Toggle output panel
- `<leader>np` — Toggle summary panel
- `<leader>nw` — Toggle watch mode
- `<leader>nx` — Stop running test
- `<leader>na` — Attach to running test
- `<leader>nc` — Run nearest with custom command (prompts)
- `<leader>nC` — Run file with custom command (prompts)

Summary panel: `r` run, `d` debug, `o` output, `i` jump to file, `w` watch, `J/K` next/prev failed, `m` mark, `R` run marked.

Runners: Jest, Vitest, Pytest, Playwright, vim-test fallback.

### 99 AI Plugin (`<leader>9`)

- `<leader>9f` — Fill in function (AI completes function body)
- `<leader>9v` [v] — Visual selection to AI
- `<leader>9a` [v] — Ask with prompt (visual + custom prompt), `:w` to submit, `q` to cancel
- `<leader>9s` [v] — Stop all AI requests

### Harpoon (`<leader>h`)

- `<leader>hh` — Toggle harpoon menu
- `<leader>ha` — Add file to harpoon
- `<leader>hc` — Clear all harpoon marks
- `<leader>hn/hp` — Next/previous harpoon file
- `<leader>h1-4` — Jump to harpoon file 1-4
- `<leader>ht` — Telescope harpoon picker

In harpoon menu: `<C-v>` vertical split, `<C-x>` horizontal split, `<C-t>` new tab.

### Diagnostics (`<leader>d`)

- `<leader>dd` — Toggle all diagnostics (Trouble)
- `<leader>dD` — Buffer diagnostics only (Trouble)
- `<leader>dq` — Quickfix list (Trouble)
- `<leader>dl` — Location list (Trouble)
- `<leader>dc` — Compile (prompt for command)
- `<leader>dr` — Recompile (run last command)
- `<leader>di` — Interrupt compilation
- `<leader>df` — Send compile files to quickfix (in compilation buffer)
- `<leader>dn/dp` — Next/previous diagnostic
- `<leader>de` — Open floating diagnostic
- `[d` / `]d` — Previous/next diagnostic (vim-style)

Compile workflow: `<leader>dc` → run e.g. `yarn typecheck` → `<leader>df` to extract errors → navigate in Trouble → `<leader>dr` to recompile.

### Treesitter Text Objects

- `af/if` [o,x] — Around/inside function
- `ac/ic` [o,x] — Around/inside class
- `aa/ia` [o,x] — Around/inside argument
- `]m/[m` — Next/previous function start
- `]M/[M` — Next/previous function end
- `]]/[[` — Next/previous class start
- `]/[[]` — Next/previous class end
- `<leader>a` — Swap argument with next
- `<leader>A` — Swap argument with previous

### Copy to Clipboard (`<leader>c`)

- `<leader>cf` — Copy filename
- `<leader>cr` — Copy relative path
- `<leader>cp` — Copy full path
- `<leader>cw` — Copy working directory
- `<leader>cl` — Copy line reference (file:line)
- `<leader>cd` — Copy diagnostic (current line)
- `<leader>cD` — Copy diagnostic with context (for LLM)
- `<leader>ca` — Copy all diagnostics in buffer

### Git (`<leader>g`)

- `<leader>gs` [n,v] — Stage hunk
- `<leader>gr` [n,v] — Reset hunk
- `<leader>gS` — Stage buffer
- `<leader>gR` — Reset buffer
- `<leader>gu` — Undo stage hunk
- `<leader>gp` — Preview hunk
- `<leader>gb` — Blame line
- `<leader>gd` — Diff against index
- `<leader>gD` — Diff against last commit
- `]c/[c` — Next/previous hunk

Git conflicts: `co` ours, `ct` theirs, `cb` both, `c0` none, `]x/[x` next/prev conflict.

### Markdown / zk (`<leader>z`)

- `<leader>zn` — New note (prompt for title)
- `<leader>zo` — Browse all notes (telescope)
- `<leader>zt` — Browse by tags (telescope)
- `<leader>zf` [n,v] — Search notes by content
- `<leader>zb` — Backlinks to current note
- `<leader>zl` — Outbound links from current note
- `Enter` — Follow wikilink (in md files in zk notebook)
- `K` — Preview linked note hover (in md files in zk notebook)

### Search (Telescope) (`<leader>s`)

- `<leader>sf` — Find files
- `<leader>sg` — Live grep
- `<leader>sw` — Search current word
- `<leader>sb` — Search buffers
- `<leader>sh` — Search help
- `<leader>sk` — Search keymaps
- `<leader>ss` — Search select (Telescope pickers)
- `<leader>sd` — Search diagnostics
- `<leader>sr` — Resume last search
- `<leader>sn` — Search Neovim config files
- `<leader>s.` — Recent files
- `<leader>s/` — Live grep in open files
- `<leader>/` — Fuzzy search current buffer

### LSP (`<leader>l` and `g*`)

- `<leader>la` [n,x] — Code action
- `<leader>lr` — Rename symbol
- `<leader>lh` — Toggle inlay hints
- `<leader>ls` — Restart LSP
- `<leader>li` — LSP info
- `gd` — Go to definition
- `gD` — Go to declaration
- `gr` — Go to references
- `gi` — Go to implementation
- `gt` — Go to type definition
- `gO` — Document symbols
- `gW` — Workspace symbols
- `K` — Hover documentation

### Snippets

- `<C-j>` [i,s] — Jump to next snippet placeholder
- `<C-k>` [i,s] — Jump to previous snippet placeholder

### Visual Mode

- `<C-j>` [v] — Move selection down (Schlepp)
- `<C-k>` [v] — Move selection up (Schlepp)

### Toggle (`<leader>t`)

- `<leader>tb` — Toggle git blame line
- `<leader>tD` — Toggle git deleted (preview inline)
- `<leader>tu` — Toggle Undotree

### Project/Files (`<leader>p`)

- `<leader>pp` [n,v] — Save and open Oil file browser

### Other

- `<Esc>` — Clear search highlights
- `<Esc><Esc>` [t] — Exit terminal mode
- `<C-t>` [i] — Tab out of brackets (neotab)

### Oil (file browser)

- `-` — Open parent directory
- `<CR>` — Open file/directory
- `g?` — Show help
- `g.` — Toggle hidden files

---

## vifm (Fast File Manager)

Open via `prefix+y` in tmux, or `vf` in shell (auto light/dark theme).

### Navigation

- `j/k` — Down / Up
- `h/l` — Parent / Enter directory
- `gg/G` — Top / Bottom
- `Tab` — Switch panes
- `Ctrl+H/Ctrl+L` — Move focus left/right pane

### Bookmarks

- `'d` — Jump to ~/dev
- `'s` — Jump to ~/dev/setup
- `'S` — Jump to ~/Documents/screenrec
- `'c` — Jump to ~/.config
- `'h` — Jump to ~
- `'D` — Jump to ~/Downloads
- `m<key>` — Set bookmark at current dir

### File Operations

- `yy` — Yank (copy) file
- `dd` — Delete file
- `p` — Paste
- `cw` — Rename
- `af` — Create new file
- `ad` — Create new directory

### Useful Commands

- `w` — Toggle preview pane
- `q` — Quit
- `zh` — Toggle hidden files
- `,s` — Open shell
- `,f` — Open in Finder
- `,g` — Open lazygit
- `,z` — Zoxide jump (`:Z <query>`)
- `yp` — Copy full path to clipboard
- `yn` — Copy filename to clipboard
- `:Z <query>` — Zoxide jump
- `:lg` — Open lazygit
- `:finder` — Open in Finder
- `:diff` — Diff selected files in nvim

---

## Shell (zsh-vi-mode)

### Completion

- `Tab` — Standard completion
- `Shift+Tab` — Completion menu
- `Escape` — Cancel completion menu
- `Ctrl+R` — Atuin history search

### Directory Navigation

- `z <name>` — Zoxide jump to directory
- `vf` — vifm file manager (auto light/dark)
- `mc` — Midnight Commander (auto light/dark)

### Git Shortcuts

All commands auto-detect the default branch (`main`/`master`). Add `-h` as first arg to skip hooks (`HUSKY=0`).

- `glg` — Log with graph + decorate (`glg -a` for all branches)
- `gfom` — Fetch origin default branch
- `grbom` — Rebase onto origin/default branch
- `grbi <n>` — Interactive rebase last n commits
- `grthom` — Hard reset to origin/default branch
- `grts <n>` — Soft reset last n commits
- `gwt <branch>` — Create worktree + tmux session
- `gwtr <branch>` — Remove worktree + cleanup

### Markdown / zk

- `zk new --title "..."` — Create a new note
- `zk edit -i` — Search notes with fzf
- `zk tag list` — List all tags
- `zk list --orphan` — Find unlinked notes
- `zk recent` — Edit recent notes (alias)
