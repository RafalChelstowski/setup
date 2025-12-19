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
| **wtfutil**          | Terminal dashboard for dev info (sesh HOME session)          |
| **bottom (btm)**     | System monitor with temps (paired with wtfutil in dashboard) |
