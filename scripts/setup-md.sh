#!/usr/bin/env bash

# setup-md.sh - One-time setup for ~/md notebook with zk and zk-mcp
#
# Usage: ./scripts/setup-md.sh
#
# This script:
# - Creates ~/md/ directory and .zk/ notebook structure
# - Copies zk config and templates from the setup repo
# - Clones zk-mcp (MCP server for zk) to ~/.local/share/zk-mcp/
# - Sets up a cron job to keep the zk index fresh
# - Prints a checklist for remaining manual steps

set -e

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
md_dir="$HOME/md"
zk_dir="$md_dir/.zk"
zk_mcp_dir="$HOME/.local/share/zk-mcp"

echo "Setting up markdown notebook..."
echo ""

# 1. Create ~/md/ if it doesn't exist
if [ -d "$md_dir" ]; then
  echo "  ~/md/ already exists, skipping creation"
else
  mkdir -p "$md_dir"
  echo "  Created ~/md/"
fi

# 2. Create .zk/ structure
mkdir -p "$zk_dir/templates"
echo "  Created ~/md/.zk/ and ~/md/.zk/templates/"

# 3. Copy zk config
zk_config_src="$repo_dir/zk/config.toml"
zk_config_dest="$zk_dir/config.toml"
if [ ! -f "$zk_config_src" ]; then
  echo "Error: zk/config.toml not found at $zk_config_src"
  exit 1
fi
cp "$zk_config_src" "$zk_config_dest"
echo "  Copied zk/config.toml -> ~/md/.zk/config.toml"

# 4. Copy templates
zk_template_src="$repo_dir/zk/templates/default.md"
zk_template_dest="$zk_dir/templates/default.md"
if [ -f "$zk_template_src" ]; then
  cp "$zk_template_src" "$zk_template_dest"
  echo "  Copied zk/templates/default.md -> ~/md/.zk/templates/default.md"
fi

# 5. Create .gitignore (ignore the SQLite database)
gitignore_dest="$md_dir/.gitignore"
if [ ! -f "$gitignore_dest" ]; then
  cat > "$gitignore_dest" << 'EOF'
.zk/notebook.db
.DS_Store
EOF
  echo "  Created ~/md/.gitignore"
else
  echo "  ~/md/.gitignore already exists, skipping"
fi

# 6. Clone zk-mcp
echo ""
if [ -d "$zk_mcp_dir" ]; then
  echo "  zk-mcp already cloned at $zk_mcp_dir"
  echo "  Updating..."
  git -C "$zk_mcp_dir" pull --quiet 2>/dev/null || echo "  Warning: could not update zk-mcp"
else
  echo "  Cloning zk-mcp to $zk_mcp_dir..."
  mkdir -p "$(dirname "$zk_mcp_dir")"
  git clone --quiet https://github.com/koei-kaji/zk-mcp.git "$zk_mcp_dir"
  echo "  Cloned zk-mcp"
fi

# 7. Install zk-mcp dependencies
if command -v uv &>/dev/null; then
  echo "  Installing zk-mcp dependencies with uv..."
  (cd "$zk_mcp_dir" && uv sync --quiet 2>/dev/null)
  echo "  zk-mcp dependencies installed"
else
  echo "  Warning: uv not found. Install with: brew install uv"
  echo "  Then run: cd $zk_mcp_dir && uv sync"
fi

# 8. Run zk index
echo ""
if command -v zk &>/dev/null; then
  echo "  Running zk index..."
  (cd "$md_dir" && zk index --quiet 2>/dev/null) || true
  echo "  zk index complete"
else
  echo "  Warning: zk not found. Install with: brew install zk"
fi

# 9. Set up cron job for zk index
cron_job='*/5 * * * * cd $HOME/md && /opt/homebrew/bin/zk index --quiet 2>/dev/null'
if crontab -l 2>/dev/null | grep -q "zk index"; then
  echo "  Cron job for zk index already exists, skipping"
else
  (crontab -l 2>/dev/null; echo "$cron_job") | crontab -
  echo "  Added cron job: zk index every 5 minutes"
fi

echo ""
echo "Markdown notebook setup complete!"
echo ""
echo "Remaining manual steps:"
echo "  1. Initialize git repo:"
echo "     cd ~/md && git init && git add . && git commit -m 'initial'"
echo ""
echo "  2. Add remote (personal or company GitHub):"
echo "     git remote add origin <your-github-url>"
echo "     git push -u origin main"
echo ""
echo "  3. Ensure Python 3.12+:"
echo "     pyenv global 3.12.4"
echo ""
echo "  4. Reload shell and tmux:"
echo "     source ~/.zshrc"
echo "     tmux source-file ~/.config/tmux/tmux.conf"
echo ""
echo "  5. Restart neovim for new plugins"
echo ""
echo "  6. Re-run setup-opencode-config.sh for MCP server config:"
echo "     ./scripts/setup-opencode-config.sh"
echo ""
