# Dev Setup Review - Q1 2026 Changes

## 0. Removed glow, settled on nvim for markdown viewing (Feb 2026)

**Change:** Removed `glow` as the markdown viewer. Evaluated glow → mdfried → md-tui (`mdt`), but all had deal-breaking issues: glow had no working search, mdfried had no syntax highlighting and broken input in tmux popups, md-tui had broken search in rendered content. Settled on **nvim** with `render-markdown.lua` — reliable search, proper rendering, and already configured.

**Migration steps:**
```bash
brew uninstall glow
rm -rf ~/.config/glow/
rm -f ~/.local/bin/glow-md
```

**Files removed:**
- `glow/` directory (glow.yml, base16-dark.json, base16-light.json)
- `scripts/glow-md` wrapper

**Files updated:**
- `tmux/tmux.conf` — `prefix+m` opens fzf note picker (cat preview) → nvim in new window
- `scripts/setup-links.sh` — removed glow config and glow-md symlink blocks
- `KEYBINDINGS.md` — rewritten without tables (bullet lists), removed Dashboard/MC/Troubleshooting sections (732 → 344 lines)

## 1. tmux PATH fix (tmux/tmux.conf:19)

**Problem:** Commands bound to `prefix+J` (opencode) and `prefix+y` (vf) stopped working after Mac restart — pane flashes and closes immediately.

**Root cause:** `set-environment -g "PATH"` was missing `~/.opencode/bin` and `~/.local/bin`.

**Change:** Replaced the static `set-environment` line with a `run-shell` that also dynamically resolves the nvm default node version:

```tmux
run-shell 'tmux set-environment -g "PATH" "$HOME/.nvm/versions/node/v$(cat "$HOME/.nvm/alias/default" 2>/dev/null)/bin:$HOME/.opencode/bin:$HOME/.local/bin:$HOME/.bun/bin:/opt/homebrew/bin:/usr/local/bin:/usr/sbin:/usr/bin:/bin"'
```

Note: `/usr/sbin` was also added — needed by tmux2k's cpu/ram plugins (`sysctl`, `system_profiler`).

## 2. Node management — remove Homebrew node, use nvm only

**Problem:** Homebrew node (`/opt/homebrew/bin/node`) shadowed nvm's default version. Changing `nvm alias default` had no effect until nvm lazy-loaded.

**Changes:**

**Terminal commands (run on the other machine):**

```bash
brew uninstall prettier
brew uninstall node
```

**zsh/zshrc.common** — added eager nvm PATH (before lazy-load block):

```bash
# NVM default node on PATH eagerly (~0ms, avoids full nvm init ~2.5s)
export NVM_DIR="$HOME/.nvm"
export PATH="$NVM_DIR/versions/node/v$(cat "$NVM_DIR/alias/default" 2>/dev/null)/bin:$PATH"
```

**After uninstalling Homebrew node, reinstall prettier globally via nvm:**

```bash
npm install -g prettier
```

## 3. tmux2k status bar — replace battery/time with cwd and cpu/ram

**Problem:** Battery and time info is redundant with the macOS menu bar.

**Change (tmux/tmux.conf):**

```tmux
set -g @tmux2k-left-plugins "session git"
set -g @tmux2k-right-plugins "cwd group"
set -g @tmux2k-group-plugins "cpu ram"
set -g @tmux2k-refresh-rate 60
```

## 4. Git lock contention — "another git process already in progress"

**Problem:** Three systems (tmux2k, starship, gitsigns) poll git concurrently, causing lock file contention.

**Changes across 4 files:**

**zsh/zshrc.common:**

```bash
export GIT_OPTIONAL_LOCKS=0
```

**tmux/tmux.conf:**

```tmux
set -g @tmux2k-refresh-rate 60
```

(already included in #3 above)

**starship/starship.toml** — added at the top:

```toml
command_timeout = 300
```

**nvim/lua/kickstart/plugins/gitsigns.lua** — added to opts:

```lua
opts = {
  update_debounce = 500,
  ...
}
```

## 5. Up arrow "Loading..." flash

**Problem:** Pressing up arrow showed "Loading..." briefly and did nothing, caused by zsh-autocomplete's history search widget conflicting with `list-lines 0`.

**Change (zsh/zshrc.common)** — added to `zvm_after_init()`:

```bash
bindkey '^[[A' up-line-or-history       # Up arrow
bindkey '^[[B' down-line-or-history     # Down arrow
```

## 6. Double-escape breaking vim mode

**Problem:** Pressing Esc twice quickly triggered zsh-autocomplete's Alt+Up history search instead of staying in vim normal mode.

**Change (zsh/zshrc.common)** — added to `zvm_after_init()`:

```bash
bindkey -r '^[^[[A'                     # Remove Alt+Up
bindkey -r '^[^[[B'                     # Remove Alt+Down
bindkey -r '^[^[OA'                     # Remove Alt+Up variant
bindkey -r '^[^[OB'                     # Remove Alt+Down variant
```

## 7. Git shortcut functions

**Added shell functions to `zsh/zshrc.common`** for common git operations:

| Command | Action |
|---------|--------|
| `gfom` | `git fetch origin <default-branch>` |
| `grom` | `git rebase origin/<default-branch>` |
| `gri <n>` | `git rebase -i HEAD~<n>` |
| `grhom` | `git reset --hard origin/<default-branch>` |
| `grs <n>` | `git reset --soft HEAD~<n>` |

Features:
- Auto-detects default branch (`main`/`master`) via `git symbolic-ref refs/remotes/origin/HEAD`
- All commands support `-h` as first argument to prepend `HUSKY=0` (skip git hooks)
- Example: `grom -h` runs `HUSKY=0 git rebase origin/master`

Also updated `KEYBINDINGS.md` with a Git Shortcuts section under Shell (includes `gwt`/`gwtr` worktree helpers).

## Quick setup checklist for the other machine

1. Pull the latest repo changes
2. Run `brew uninstall prettier node` (if installed via Homebrew)
3. Run `npm install -g prettier` (via nvm)
4. Run `brew install zk marksman` (markdown workflow tools)
5. Run `./scripts/setup-links.sh` (updates symlinks)
6. Run `./scripts/setup-md.sh` (creates ~/md notebook, clones zk-mcp)
7. Run `./scripts/setup-opencode-config.sh` (updates opencode MCP config)
8. Ensure Python 3.12+: `pyenv global 3.12.4`
9. Initialize ~/md: `cd ~/md && git init && git add . && git commit -m "initial"`
10. Add remote: `git remote add origin <github-url> && git push -u origin main`
11. Reload shell: `source ~/.zshrc`
12. Reload tmux: `tmux source-file ~/.config/tmux/tmux.conf`
13. Restart neovim for new plugins (zk-nvim, render-markdown.nvim, gitsigns change)

## 8. Markdown workflow — zk, zk-mcp, opencode skill

**Added a full markdown note-taking, browsing, and LLM-integration workflow.**

### New tools to install

```bash
brew install zk marksman
```

- **zk** — CLI note-taking with wikilinks, tags, backlinks, fzf search, and LSP server
- **marksman** — Markdown LSP (cross-file link intelligence)

### New files in setup repo

| File | Purpose |
|------|---------|
| `zk/config.toml` | zk notebook config (copied to ~/md/.zk/ by setup-md.sh) |
| `zk/templates/default.md` | Default note template with frontmatter |
| `skills/zk-notes/SKILL.md` | OpenCode agent skill — teaches LLMs to search/read/create notes via zk-mcp |
| `scripts/setup-md.sh` | One-time setup: creates ~/md, .zk config, clones zk-mcp, sets up cron |
| `nvim/lua/custom/plugins/zk.lua` | zk-nvim plugin with telescope and keymaps |
| `nvim/lua/custom/plugins/render-markdown.lua` | In-buffer markdown rendering |

### Changes to existing files

| File | Change |
|------|--------|
| `tmux/tmux.conf` | Added `prefix+m` to open markdown note picker with fzf (preview via bat) |
| `zsh/zshrc.common` | Added `export ZK_NOTEBOOK_DIR="$HOME/md"` |
| `scripts/setup-links.sh` | Added opencode skills symlinks |
| `opencode/opencode.json` | Added zk-mcp MCP server + zk-notes skill permission |
| `KEYBINDINGS.md` | Added Markdown/zk sections for neovim and shell |

### Architecture

```
~/md/                   # separate git repo (personal or company GitHub)
├── .zk/                # zk config + SQLite index (created by setup-md.sh)
└── (your notes)        # organized however you want

~/dev/setup/            # this repo (tool configs only, no note content)
├── zk/                 # zk config source (copied to ~/md/.zk/)
├── skills/zk-notes/    # agent skill (symlinked to opencode skills)
└── scripts/setup-md.sh # one-time setup

~/.local/share/zk-mcp/  # MCP server (cloned by setup-md.sh)
```

### Workflow

- **Browse notes:** `prefix+m` in tmux opens fzf note picker (cat preview) → opens in nvim (new window)
- **Create/edit:** In neovim, `<leader>zn` to create, `<leader>zo` to browse, `[[wikilinks]]` auto-complete
- **Search:** `<leader>zf` in neovim or `zk edit -i` in terminal (fzf-powered)
- **LLM integration:** OpenCode can search/read/create notes via zk-mcp MCP server, guided by the zk-notes skill

## 9. Fixes: nvm path v-prefix + opencode MCP env key

**Problem 1:** nvm's `~/.nvm/alias/default` file stores the version number inconsistently across machines — some have `24.11.1` (no `v`), others have `v24.11.1`. The eager PATH resolution broke on machines where the `v` was missing since directories are always named `v<version>`.

**Fix (zsh/zshrc.common + tmux/tmux.conf):** Read the alias, prepend `v` if missing:

```bash
_nvm_default=$(cat "$NVM_DIR/alias/default" 2>/dev/null)
[[ "$_nvm_default" != v* ]] && _nvm_default="v$_nvm_default"
export PATH="$NVM_DIR/versions/node/$_nvm_default/bin:$PATH"
```

**Problem 2:** opencode.json used `"environment"` instead of `"env"` for the zk-mcp MCP server config.

**Fix:** Renamed to `"env"` per the opencode config schema.

## 10. OpenCode: unified installation method (bun only)

**Problem:** Personal machine had curl-installed opencode (`~/.opencode/bin/opencode`, 106MB native binary), work machine had bun-installed (`bun add -g opencode-ai`). Different upgrade methods (`opencode upgrade` via curl vs `bun update -g`), redundant `~/.opencode/` directory with duplicate plugin installations.

**Changes:**

**Removed files:**
- `scripts/cleanup-opencode.sh` — outdated, referenced old workflow
- `scripts/setup-opencode-config.sh` — outdated, replaced by simple `cp` command

**Updated files:**

| File | Change |
|------|--------|
| `INSTALL.md` | Replaced script-based setup with simple 3-command manual guide |
| `scripts/setup-links.sh` | Removed reference to deleted setup-opencode-config.sh |
| `tmux/tmux.conf:19` | Removed `$HOME/.opencode/bin` from tmux PATH |

**Cleaned up on personal machine:**
- Removed `~/.opencode/` directory entirely (legacy from curl installer — redundant plugins, empty bin/)
- Binary now at `~/.bun/bin/opencode` (symlink to bun global packages)

**For work machine:**

```bash
# 1. Remove legacy ~/.opencode/ directory (if it exists)
rm -rf ~/.opencode/

# 2. Remove from ~/.zshrc (if present):
#    # opencode
#    export PATH=/Users/.../.opencode/bin:$PATH

# 3. Verify bun installation is in place
which opencode        # Should show ~/.bun/bin/opencode
opencode --version

# 4. If not installed via bun:
bun add -g opencode-ai

# 5. Ensure config exists
ls ~/.config/opencode/opencode.json
# If missing:
mkdir -p ~/.config/opencode
cp ~/dev/setup/opencode/opencode.json ~/.config/opencode/

# 6. Ensure skills symlink exists (created by setup-links.sh)
ls -la ~/.config/opencode/skills
```

**Going forward (both machines):**
- **Install:** `bun add -g opencode-ai`
- **Upgrade:** `bun update -g opencode-ai`
- **Binary:** `~/.bun/bin/opencode`
- **Config:** `~/.config/opencode/opencode.json` (copied, not symlinked)
- **Plugin cache:** `~/.cache/opencode/node_modules/` (managed automatically)
- **Plugin deps:** `~/.config/opencode/package.json` (managed automatically, `bun install` at startup)

## 11. New sesh sessions — KEYBINDS and SCREENREC

**Added two new configured sessions to `sesh/sesh.toml`:**

| Session | Path | Startup Command |
|---------|------|-----------------|
| KEYBINDS | `~/dev/setup` | `nvim KEYBINDINGS.md` — with render-markdown.lua, reliable `/` search |
| SCREENREC | `~/Documents/screenrec` | `vf -c 'set sort=-mtime'` — vifm dual-pane sorted newest first |

Access via `Ctrl+F` (sesh picker) or `Ctrl+F` → `Ctrl+G` (config sessions).

## 12. vifm filetype fix — images/videos now open correctly

**Problem:** `filetype * nvim %c` was the first rule in `vifm/vifmrc`, catching all files before specific rules for images, videos, and PDFs could match. Opening an image or video in vifm would show garbled output in nvim.

**Fix (vifm/vifmrc):** Moved `filetype * nvim %c` to the end of all filetype rules as a fallback. Specific rules (images → `open`, videos → `open`, PDFs → `open`, archives → extract) now match first.

## 13. Sesh picker enhancements — preview and window-level navigation

### Session preview

**Added `sesh preview` to the `Ctrl+F` picker.** When browsing sessions, the right pane now shows a live capture of what's running in each session.

```tmux
--preview-window 'right:55%' \
--preview 'sesh preview {}'
```

### Window-level navigation (`Ctrl+W`)

**Added `Ctrl+W` bind to the sesh picker** that lists all windows across all tmux sessions. Selecting a window switches directly to that session and window.

- Uses `tmux list-windows -a` to list all windows (format: `session:window: command`)
- Selection routes through `tmux switch-client -t session:window` instead of `sesh connect`
- Preview uses `tmux capture-pane` for window entries, `sesh preview` for session entries

**Changes to tmux/tmux.conf:**
- Sesh picker now wraps selection in routing logic (window entries → `tmux switch-client`, session entries → `sesh connect`)
- Added `ctrl-w` reload bind with `tmux list-windows`
- Preview command is context-aware (detects window format)
- Updated header hint: `^a all ^t tmux ^w windows ^g configs ^x zoxide ^d tmux kill ^f find`

## 14. `prefix+l` — last session toggle

**Added `prefix+l` (lowercase) as alias for `prefix+L`** — both now run `sesh last` to toggle between the two most recent sessions. Eliminates the need to hold Shift.

**Change (tmux/tmux.conf):**
```tmux
bind -N "last-session (via sesh) " l run-shell "sesh last"
```

## 15. Rustup installed for cargo builds

**Installed rustup** to manage Rust independently from Homebrew. Homebrew rust was stuck at 1.87.0, but md-tui and mdfried require 1.90+.

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

Rust 1.93.1 installed. Cargo binary at `~/.cargo/bin/cargo`. Also installed `chafa` (terminal graphics library) as a build dependency.

**Important:** Ensure `~/.cargo/bin` comes before `/opt/homebrew/bin` in PATH when running `cargo install`, or use `PATH="$HOME/.cargo/bin:$PATH" cargo install ...` to force the correct Rust version.
