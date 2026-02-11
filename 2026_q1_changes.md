# Dev Setup Review - Q1 2026 Changes

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

## Quick setup checklist for the other machine

1. Pull the latest repo changes
2. Run `brew uninstall prettier node` (if installed via Homebrew)
3. Run `npm install -g prettier` (via nvm)
4. Reload shell: `source ~/.zshrc`
5. Reload tmux: `tmux source-file ~/.config/tmux/tmux.conf`
6. Restart neovim for gitsigns change
