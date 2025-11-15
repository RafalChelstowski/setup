#!/bin/sh
# Create a new tmux window with opencode
tmux split-window -h -l 35% -c "#{pane_current_path}" 'opencode'
