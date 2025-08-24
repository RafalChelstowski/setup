#!/bin/sh
# Get the PID of the process in the current tmux pane
PANE_PID=$(tmux display-message -p "#{pane_pid}")

# Get the command name of the process
PANE_CMD=$(ps -p "$PANE_PID" -o comm=)

# List of common shells (adjust if you use others, e.g., fish)
SHELLS="bash zsh sh"

# Check if the pane is running a shell
if echo "$SHELLS" | grep -qw "$PANE_CMD"; then
    # Pane is running a shell; show a message instead of sending EOF
    tmux display-message "Use Ctrl-b x to kill pane, Ctrl-b X to kill window"
else
    # Pane is running a non-shell process (e.g., nvim); send Ctrl-d to it
    tmux send-keys C-d
fi
