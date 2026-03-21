#!/usr/bin/env bash

cat <<'EOF'
SessionX Help

Enter           open selected session or create one from query
Esc             close SessionX
Backspace       delete one character from query

Ctrl-p          move selection up
Ctrl-n          move selection down
Ctrl-u          scroll preview up
Ctrl-d          scroll preview down

Ctrl-r          rename selected session
Alt-Backspace   kill selected session

Ctrl-w          window mode
Ctrl-t          tree mode
Ctrl-x          config path mode
Ctrl-e          expand current directory into session candidates
Ctrl-f          zoxide mode
Ctrl-b          go back to the main session list

Alt-p           toggle preview pane
?               show this help

Tips
- Type to fuzzy search sessions
- Press Enter on a new name to create a session
- Some commands depend on optional tools like zoxide, tmuxinator, or fzf-marks
EOF
