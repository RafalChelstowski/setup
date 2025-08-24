#!/bin/sh
# Default to 35% if no width provided
WIDTH="${1:-35%}"
tmux new-window -c "#{pane_current_path}"
tmux split-window -h -l "$WIDTH" -c "#{pane_current_path}"
