#!/usr/bin/env bash

# This script links your dotfiles for each tool from this repository,
# backing up existing configs as tool_old if present.
tool_dirs=(atuin nvim sesh opencode ghostty tmux yazi)

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

echo "All tool configs backed up and linked!"
