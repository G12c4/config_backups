#!/usr/bin/env bash

# Session: hx-op-term
# Left pane: helix editor
# Right top pane: opencode
# Right bottom pane: terminal

# Set session root to current directory
session_root="$PWD"

# Check if session already exists
if tmux has-session -t hx-op-term 2>/dev/null; then
  tmux attach -t hx-op-term
  exit 0
fi

# Create new session with name (this creates window 1 with pane 1)
tmux new-session -d -s hx-op-term -c "$session_root"

# Split window vertically (left/right) - creates pane 2 on right
tmux split-window -h -t hx-op-term:1 -c "$session_root"

# Right pane - split horizontally (top/bottom) - creates pane 3 on bottom right
tmux split-window -v -t hx-op-term:1.2 -c "$session_root"

# Left pane (pane 1) runs helix with file picker
tmux send-keys -t hx-op-term:1.1 "hx ." C-m Space f

# Top right pane (pane 2) runs opencode  
tmux send-keys -t hx-op-term:1.2 "opencode" C-m

# Bottom right pane (pane 3) is just a terminal

# Attach to session
tmux attach -t hx-op-term
