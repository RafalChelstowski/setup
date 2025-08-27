#!/bin/sh
# Create a new tmux window with lazygit
tmux new-window -c "#{pane_current_path}" 'lazygit'
