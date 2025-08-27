#!/bin/sh
# Create a new tmux window with yazi
tmux new-window -c "#{pane_current_path}" 'yazi'