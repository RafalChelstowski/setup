# Setup Instructions

## Brew Packages

```bash
brew install tmux
brew install fzf
brew install zoxide
brew install starship
brew install eza
brew install midnight-commander
brew install vifm
brew install wtfutil
brew install bottom
brew install lazygit
brew install ripgrep
brew install fd
brew install atuin
brew install neovim
brew install pyenv
brew install nvm
brew install rust
brew install zsh-autocomplete
brew install zsh-syntax-highlighting
brew install zsh-vi-mode
```

## Post-install

1. Clone this repo
2. Run `scripts/setup-links.sh` to symlink configs to `~/.config/`
3. Copy `zsh/zshrc.template` to `~/.zshrc` and edit machine-specific settings:
   - `BREW_PREFIX`: `/opt/homebrew` (Apple Silicon) or `/usr/local` (Intel Mac)
   - PATH exports as needed
   - Machine-specific env vars (AWS_PROFILE, etc.)
4. Install tmux plugins: `prefix + I` in tmux
5. Reload tmux config: `prefix + R` (or `tmux source ~/.config/tmux/tmux.conf`)
6. Reload shell: `source ~/.zshrc`

## Performance Notes

- **NVM and pyenv are lazy-loaded** — first call to `node`/`python` has ~500ms delay, then instant
- **BREW_PREFIX is hardcoded** — avoids 3x `$(brew --prefix)` calls (~200ms savings)
- **Starship init is patched** — fixes vim mode indicator recursion bug (upstream PR #6398)
- **zsh-autocomplete real-time list disabled** — `list-lines 0` prevents typing lag while keeping Shift+Tab menu
- Expected shell startup: **~200ms**

## Key Bindings

- `Ctrl+R` — atuin history search
- `Tab` — standard completion
- `Shift+Tab` — completion menu (navigate with arrows, Ctrl+J/K)
- `Escape` — cancel completion menu
- `Ctrl+T` / `Alt+C` — not bound (fzf shell integration removed, use zoxide/mc instead)

## Tool Roles

| Tool                 | Purpose                                                      |
| -------------------- | ------------------------------------------------------------ |
| **atuin**            | Shell history search (`Ctrl+R`)                              |
| **zsh-autocomplete** | Completion menu (`Shift+Tab`)                                |
| **zoxide**           | Smart directory jumping (`z foo`)                            |
| **vifm**             | Fast file manager (`prefix+y` in tmux, or `vf` in shell) - vim-native    |
| **mc**               | Full file manager (`prefix+Y` in tmux, or `mc` in shell) - two-panel     |
| **fzf**              | Used by tmux plugins (extrakto, sesh), not shell keybindings |
| **starship**         | Prompt with git status, vim mode indicator                   |
| **zsh-vi-mode**      | Vim keybindings in shell                                     |
| **wtfutil**          | Terminal dashboard for dev info (sesh HOME session), auto light/dark theme |
| **bottom (btm)**     | System monitor with temps (paired with wtfutil in dashboard), auto light/dark theme |
| **OpenCode**         | AI coding agent (install globally with `bun add -g opencode-ai`)                    |

## OpenCode Setup

OpenCode is installed globally via bun. Plugins and dependencies are managed automatically.

**Installation:**

```bash
# Install OpenCode CLI globally
bun add -g opencode-ai

# Copy config file (do NOT symlink — OpenCode creates package.json/node_modules here)
mkdir -p ~/.config/opencode
cp opencode/opencode.json ~/.config/opencode/

# Skills symlink is created by setup-links.sh, or manually:
ln -sf ~/dev/setup/skills ~/.config/opencode/skills
```

**Notes:**
- Config: `~/.config/opencode/opencode.json` (copied, not symlinked)
- Plugin cache: `~/.cache/opencode/node_modules/` (managed by OpenCode)
- Local plugin deps: `~/.config/opencode/package.json` (managed by OpenCode, runs `bun install` at startup)
- Binary: `~/.bun/bin/opencode` (symlink to bun global packages)

**Upgrade:**

```bash
bun update -g opencode-ai
```

**Verify:**

```bash
which opencode        # ~/.bun/bin/opencode
opencode --version
```

## OpenCode Troubleshooting

### Multiple OpenCode Installations

**Problem**: opencode installed via multiple methods (curl, brew, bun).

**Solution**: Keep only bun installation:
```bash
# Remove brew version (if exists)
brew uninstall opencode 2>/dev/null

# Remove curl version (if exists)
rm -rf ~/.opencode/

# Remove conflicting PATH entry from ~/.zshrc (if present):
# export PATH=/Users/.../.opencode/bin:$PATH
```

### Tmux uses wrong OpenCode version

**Problem**: Tmux doesn't inherit shell PATH, uses old binary.

**Check:**
```bash
tmux show-environment -g | grep PATH
```

**Fix**: Already configured in `tmux/tmux.conf:19` — PATH includes `$HOME/.bun/bin`. Reload:
```bash
tmux source-file ~/.config/tmux/tmux.conf
```

### 99 Plugin Model Configuration

**Problem**: 99 plugin uses default model (`opencode/claude-sonnet-4-5`) instead of configured model.

**Symptoms**:
- 99 plugin fails with error: `"process exit code: 1"`
- `opencode run -m opencode/grok-code "test"` works, but 99 fails
- 99 plugin tries to use unavailable/default model

**Solution**: Add model to 99 plugin setup in Neovim config (`~/.config/nvim/lua/custom/plugins/init.lua`):
```lua
_99.setup {
  logger = {
    level = _99.DEBUG,
    path = '/tmp/' .. basename .. '.99.debug',
    print_on_error = true,
  },
  model = "opencode/grok-code",  -- Add this line

  md_files = {
    'AGENT.md',
  },
}
```

Restart Neovim and test: `<leader>9v` in visual mode.

### OpenCode Zen Connection

**Problem**: Model not available or API key not configured.

**Diagnostic steps**:
```bash
# Check if credentials exist
opencode auth list

# Verify model availability (replace <your-key> with actual API key)
curl -s https://opencode.ai/zen/v1/models -H "Authorization: Bearer <your-key>" | grep grok-code
```

**Solution**: Connect to OpenCode Zen:
```bash
# 1. Open OpenCode TUI
opencode

# 2. Run connect command
/connect

# 3. Select "opencode" (OpenCode Zen)
# 4. Get API key from https://opencode.ai/auth
# 5. Paste API key when prompted

# Test model
opencode run -m opencode/grok-code "test"
```

### 99 Plugin Debug Logs

**Problem**: 99 plugin fails, need detailed error information.

**Diagnostic step**:
```bash
# Debug log location (based on project name)
/tmp/<project-folder>.99.debug
```

Example for setup repo:
```bash
/tmp/setup.99.debug
```
