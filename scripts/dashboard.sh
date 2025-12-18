#!/bin/bash
# Dashboard launcher script
# Creates split panes with wtfutil (65%) and btm (35%)
# For use with sesh HOME session startup_command

# Split current pane: 35% on right for btm
tmux split-window -h -p 35

# Run btm in the new right pane (with custom config)
tmux send-keys "btm --config_location ~/.config/bottom/bottom.toml" Enter

# Go back to left pane
tmux select-pane -L

# Run wtfutil in left pane
exec wtfutil
