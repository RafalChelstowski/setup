#!/usr/bin/env bash

# This script links your dotfiles for each tool from this repository,
# backing up existing configs as tool_old if present.
# Note: opencode is excluded from symlinking because it requires a separate setup
# script (setup-opencode-config.sh) to avoid bun package management issues.
tool_dirs=(atuin nvim sesh ghostty tmux mc vifm zsh wtf bottom)

# Remove all existing tool_old folders before backup
for tool in "${tool_dirs[@]}"; do
  backup="$config_dir/${tool}_old"
  if [ -e "$backup" ] || [ -L "$backup" ]; then
    rm -rf "$backup"
    echo "Removed old backup $backup"
  fi
done
repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
config_dir="$HOME/.config"

for tool in "${tool_dirs[@]}"; do
  src="$repo_dir/$tool"
  dest="$config_dir/$tool"
  backup="$config_dir/${tool}_old"
  if [ -e "$dest" ] || [ -L "$dest" ]; then
  if [ -e "$backup" ] || [ -L "$backup" ]; then
    rm -rf "$backup"
  fi
  # Remove any existing tool_old folders before backup
  if [ -e "$backup" ] || [ -L "$backup" ]; then
    rm -rf "$backup"
  fi
  mv "$dest" "$backup"
    echo "Backed up $dest to $backup"
  fi
  ln -s "$src" "$dest"
  echo "Linked $src -> $dest"
done

# Starship config (single file, not directory)
starship_src="$repo_dir/starship/starship.toml"
starship_dest="$config_dir/starship.toml"
if [ -e "$starship_dest" ] || [ -L "$starship_dest" ]; then
  rm -f "$starship_dest"
fi
ln -s "$starship_src" "$starship_dest"
echo "Linked $starship_src -> $starship_dest"

# vf script (vifm wrapper with auto light/dark theme)
mkdir -p "$HOME/.local/bin"
vf_src="$repo_dir/scripts/vf"
vf_dest="$HOME/.local/bin/vf"
if [ -e "$vf_dest" ] || [ -L "$vf_dest" ]; then
  rm -f "$vf_dest"
fi
ln -s "$vf_src" "$vf_dest"
echo "Linked $vf_src -> $vf_dest"

# dashboard script (wtfutil + btm split pane launcher)
dashboard_src="$repo_dir/scripts/dashboard.sh"
dashboard_dest="$HOME/.local/bin/dashboard"
if [ -e "$dashboard_dest" ] || [ -L "$dashboard_dest" ]; then
  rm -f "$dashboard_dest"
fi
ln -s "$dashboard_src" "$dashboard_dest"
echo "Linked $dashboard_src -> $dashboard_dest"

# wtfutil widget scripts (must be in PATH for wtfutil CmdRunner)
wtf_scripts=("dev-servers" "test-watchers" "lmstudio-status")
for script in "${wtf_scripts[@]}"; do
  src="$repo_dir/wtf/scripts/${script}.sh"
  dest="$HOME/.local/bin/wtf-${script}"
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    rm -f "$dest"
  fi
  ln -s "$src" "$dest"
  echo "Linked $src -> $dest"
done

echo "All tool configs backed up and linked!"
