#!/bin/bash

SHORTCUTS=(
    "c:New window"
    "n:Next window"
    "p:Previous window"
    ",:Rename window"
    "&:Kill window"
    "|:Split vertical"
    "-:Split horizontal"
    "x:Kill pane"
    "z:Zoom pane (toggle)"
    "o:Cycle to next pane"
    "s:List sessions"
    "d:Detach session"
    "\$:Rename session"
    "Ctrl+s:Save session"
    "Ctrl+r:Restore session"
    "[:Enter copy mode"
    "]:Paste from buffer"
    "r:Reload config"
    "t:Clock mode"
    "::Command mode"
    "O:Session switcher"
)

SELECTION=$(printf '%s\n' "${SHORTCUTS[@]}" | column -t -s ':' | fzf \
    --height=100% \
    --layout=reverse \
    --border=none \
    --prompt="⌘ " \
    --pointer="❯" \
    --header="Select a shortcut (Esc to cancel)" \
    --preview-window=hidden \
    --bind='esc:abort' \
    --color='fg:#f2e9e1,bg:#1a110e,hl:#ea9d34,prompt:#ea9d34,pointer:#ea9d34,header:#907aa9,gutter:#1a110e' \
    --no-info \
    --no-scrollbar)

[ -z "$SELECTION" ] && exit 0

KEY=$(echo "$SELECTION" | awk '{print $1}')

case "$KEY" in
    c)      tmux new-window ;;
    n)      tmux next-window ;;
    p)      tmux previous-window ;;
    ",")    tmux command-prompt -I "#W" "rename-window '%%'" ;;
    "&")    tmux kill-window ;;
    "|")    tmux split-window -h ;;
    "-")    tmux split-window -v ;;
    x)      tmux kill-pane ;;
    z)      tmux resize-pane -Z ;;
    o)      tmux select-pane -t :.+ ;;
    s)      tmux choose-tree -s ;;
    d)      tmux detach-client ;;
    '$')    tmux command-prompt -I "#S" "rename-session '%%'" ;;
    Ctrl+s) tmux run-shell ~/.tmux/plugins/tmux-resurrect/scripts/save.sh ;;
    Ctrl+r) tmux run-shell ~/.tmux/plugins/tmux-resurrect/scripts/restore.sh ;;
    "[")    tmux copy-mode ;;
    "]")    tmux paste-buffer ;;
    r)      tmux source-file ~/.tmux.conf \; display-message "Config reloaded!" ;;
    t)      tmux clock-mode ;;
    ":")    tmux command-prompt ;;
    O)      tmux run-shell "~/.tmux/plugins/tmux-sessionx/scripts/sessionx.sh" ;;
esac
