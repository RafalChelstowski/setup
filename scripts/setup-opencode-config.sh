#!/usr/bin/env bash

# This script copies the opencode.json configuration file to ~/.config/opencode/
# It does NOT create a symlink, allowing bun to manage packages separately.
#
# Usage: ./scripts/setup-opencode-config.sh
#
# This script:
# - Backs up existing ~/.config/opencode to ~/.config/opencode_old (if it exists)
# - Creates ~/.config/opencode/ directory if it doesn't exist
# - Copies opencode.json from the repository to ~/.config/opencode/
#
# IMPORTANT: This script should be run AFTER cleanup-opencode.sh and after
# manually removing the symlink with: rm ~/.config/opencode

set -e

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
config_dir="$HOME/.config"
config_name="opencode"
config_dest="$config_dir/$config_name"
config_src="$repo_dir/$config_name/opencode.json"

echo "Setting up OpenCode configuration..."

# Check if source config file exists
if [ ! -f "$config_src" ]; then
  echo "Error: opencode.json not found at $config_src"
  exit 1
fi

# Check if destination is a symlink (should be removed manually first)
if [ -L "$config_dest" ]; then
  echo "Error: $config_dest is still a symlink"
  echo "Please remove it first with: rm $config_dest"
  exit 1
fi

# Backup existing config directory if it exists
if [ -e "$config_dest" ] || [ -d "$config_dest" ]; then
  backup_dest="$config_dir/${config_name}_old"
  
  # Remove old backup if it exists
  if [ -e "$backup_dest" ] || [ -L "$backup_dest" ]; then
    echo "Removing old backup: $backup_dest"
    rm -rf "$backup_dest"
  fi
  
  echo "Backing up existing config: $config_dest -> $backup_dest"
  mv "$config_dest" "$backup_dest"
fi

# Create config directory
echo "Creating config directory: $config_dest"
mkdir -p "$config_dest"

# Copy config file
echo "Copying config file: $config_src -> $config_dest/"
cp "$config_src" "$config_dest/"

echo ""
echo "OpenCode configuration setup completed!"
echo ""
echo "Configuration location: $config_dest/opencode.json"
echo "Backup location (if any): $backup_dest"
echo ""
echo "Note: OpenCode packages will be managed by bun globally in ~/.bun/install/cache/"
