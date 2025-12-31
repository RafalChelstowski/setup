#!/usr/bin/env bash

# This script cleans up OpenCode installation files from the dev/setup repository
# and clears OpenCode packages from the bun cache.
# 
# Usage: ./scripts/cleanup-opencode.sh
# 
# This script removes:
# - package.json from opencode/ directory
# - bun.lock from opencode/ directory
# - node_modules/ from opencode/ directory
# - All opencode-related packages from ~/.bun/install/cache/

set -e

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
opencode_dir="$repo_dir/opencode"
cache_dir="$HOME/.bun/install/cache"

echo "Starting OpenCode cleanup..."

# Check if opencode directory exists
if [ ! -d "$opencode_dir" ]; then
  echo "Error: opencode directory not found at $opencode_dir"
  exit 1
fi

# Remove package files from opencode directory
echo ""
echo "Cleaning opencode directory: $opencode_dir"

if [ -f "$opencode_dir/package.json" ]; then
  echo "  Removing package.json"
  rm -f "$opencode_dir/package.json"
fi

if [ -f "$opencode_dir/bun.lock" ]; then
  echo "  Removing bun.lock"
  rm -f "$opencode_dir/bun.lock"
fi

if [ -d "$opencode_dir/node_modules" ]; then
  echo "  Removing node_modules/ directory"
  rm -rf "$opencode_dir/node_modules"
fi

echo "  ✓ opencode directory cleaned"

# Clean opencode packages from bun cache
echo ""
echo "Cleaning opencode packages from bun cache: $cache_dir"

if [ ! -d "$cache_dir" ]; then
  echo "  Cache directory not found, skipping cache cleanup"
else
  # Remove @opencode-ai directory
  if [ -d "$cache_dir/@opencode-ai" ]; then
    echo "  Removing @opencode-ai/"
    rm -rf "$cache_dir/@opencode-ai"
  fi

  # Remove opencode-* directories
  for dir in "$cache_dir"/opencode-*; do
    if [ -d "$dir" ]; then
      dir_name=$(basename "$dir")
      echo "  Removing $dir_name/"
      rm -rf "$dir"
    fi
  done

  echo "  ✓ bun cache cleaned"
fi

echo ""
echo "OpenCode cleanup completed!"
echo ""
echo "Next steps:"
echo "1. Manually remove the symlink: rm ~/.config/opencode"
echo "2. Run setup-opencode-config.sh to copy config to .config"
echo "3. Reinstall opencode globally if needed: bun install -g opencode-ai"
