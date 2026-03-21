#!/usr/bin/env bash

# Session: default (used for all new sessions)
# Four-pane layout (with dev server):
#   Top left: helix, Bottom left: dev server (smaller)
#   Top right: opencode, Bottom right: terminal (smaller)
# Three-pane layout (without dev server):
#   Left: helix, Right top: opencode, Right bottom: terminal (smaller)

# Set session root to current directory
session_root="$PWD"

# Use provided session name or default to current directory name
SESSION_NAME="${1:-$(basename "$PWD")}"

# Check if session already exists
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
  tmux attach -t "$SESSION_NAME"
  exit 0
fi

# Check for Makefile with dev or run target
DEV_CMD=""
if [ -f "$session_root/Makefile" ]; then
  if grep -qE "^(dev|run):" "$session_root/Makefile"; then
    if grep -q "^dev:" "$session_root/Makefile"; then
      DEV_CMD="make dev"
    elif grep -q "^run:" "$session_root/Makefile"; then
      DEV_CMD="make run"
    fi
  fi
fi

# Create new session with name (this creates window 1 with pane 1)
tmux new-session -d -s "$SESSION_NAME" -c "$session_root"

# Split window vertically (left/right) - creates pane 2 on right
tmux split-window -h -t "$SESSION_NAME":1 -c "$session_root"

# Split right pane horizontally (15% height) - creates pane 3 on bottom right
tmux split-window -v -t "$SESSION_NAME":1.2 -l 15% -c "$session_root"

# Pane 1 (left) runs helix with file picker
tmux send-keys -t "$SESSION_NAME":1.1 "hx ." C-m Space f

# Pane 2 (top right) runs opencode
tmux send-keys -t "$SESSION_NAME":1.2 "opencode" C-m

# Pane 3 (bottom right) is just a terminal

if [ -n "$DEV_CMD" ]; then
  # Split left pane horizontally (15% height) - creates pane 4 on bottom left for dev server
  tmux split-window -v -t "$SESSION_NAME":1.1 -l 15% -c "$session_root"
  tmux send-keys -t "$SESSION_NAME":1.4 "$DEV_CMD" C-m
fi

# Attach to session
tmux attach -t "$SESSION_NAME"
