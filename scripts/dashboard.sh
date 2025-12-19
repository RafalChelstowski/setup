#!/bin/bash
# Dashboard launcher script
# Creates split panes with wtfutil (65%) and btm (35%)
# Auto-detects macOS light/dark theme and applies matching colors
# For use with sesh HOME session startup_command

# Detect macOS theme and set config paths
if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q Dark; then
  export WTF_CONFIG=~/.config/wtf/config-dark.yml
  BTM_CONFIG=~/.config/bottom/bottom-dark.toml
else
  export WTF_CONFIG=~/.config/wtf/config-light.yml
  BTM_CONFIG=~/.config/bottom/bottom-light.toml
fi

# Split current pane: 35% on right for btm
tmux split-window -h -p 35

# Run btm in the new right pane (with theme-appropriate config)
tmux send-keys "btm --config_location $BTM_CONFIG" Enter

# Go back to left pane
tmux select-pane -L

# Run wtfutil in left pane (with theme-appropriate config)
exec wtfutil -c="$WTF_CONFIG"
