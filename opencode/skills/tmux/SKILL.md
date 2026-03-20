---
name: tmux
description: Execute commands in tmux panes and capture output. Use when you need to run commands in specific tmux panes that the user can see and interact with. Enables collaborative terminal work where the user can observe, interrupt, or take over commands. Triggers include requests to "run in pane X", "execute in tmux", "show me in terminal", or when working in a tmux session.
allowed-tools: Bash(tcmd:*), Bash(tmux:*)
---

# Tmux Pane Command Execution

Execute commands in visible tmux panes so users can see, monitor, and interact with running processes.

## The tcmd CLI Tool

`tcmd` is a custom Go CLI tool that sends commands to tmux panes and captures output in one operation.

**Location:** `~/Documents/golang/tmux-cli/tcmd` (symlinked to `~/bin/tcmd`)

**Usage:**
```bash
tcmd -p <pane> [-t <timeout>] <command>
```

**Flags:**
- `-p <pane>` - Target pane (required). Format: `session:window.pane`
- `-t <timeout>` - Maximum time to wait for command (default: 60s)
- `-h` - Show help

**Examples:**
```bash
# Basic commands
tcmd -p 2:1.3 'ls -la'
tcmd -p 2:1.3 'echo "Hello" && pwd'

# With longer timeout for slow commands
tcmd -p 2:1.3 -t 120s 'npm run build'

# Complex scripts
tcmd -p 2:1.3 'for i in 1 2 3; do echo $i; done'

# Heredocs
tcmd -p 2:1.3 'cat <<EOF
Hello World
EOF'

# Nested quotes
tcmd -p 2:1.3 "echo \"Single 'quotes' inside double\""

# Multiline scripts
tcmd -p 2:1.3 'for i in 1 2 3; do
  echo "Item $i"
done'
```

## How It Works

The tool automatically waits for command completion:

1. Wraps your command with unique start/end markers (`_TCMD_START_<id>_`, `_TCMD_END_<id>_`)
2. Executes the command in the target pane
3. Polls the pane output every 100ms until the end marker appears
4. Returns only the output between the markers

No manual wait times needed - the tool detects when commands finish.

## Finding Pane Numbers

**Method 1 (Visual):** Press `Ctrl+b q` in tmux - pane numbers appear briefly on each pane

**Method 2 (CLI):**
```bash
tmux list-panes -t <session>:<window> -F '#{pane_index}: #{pane_current_command}'
tmux list-sessions  # List all sessions
tmux list-windows -t <session>  # List windows in a session
```

## Workflow

### 1. Discover Panes
```bash
# List all sessions
tmux list-sessions

# List panes with their commands
tmux list-panes -t 2:1 -F '#{pane_index}: #{pane_current_command}'
# Output: 1: broot, 2: zsh, 3: vim
```

### 2. Execute Command
```bash
# Any command - auto-waits for completion
~/bin/tcmd -p 2:1.3 'ls -la'

# Slow commands - increase timeout if needed
~/bin/tcmd -p 2:1.3 -t 120s 'npm run build'

# Complex commands with pipes, quotes, loops
~/bin/tcmd -p 2:1.3 'echo "test" | grep test && echo "done"'
```

### 3. User Can See and Interact
The command runs in the visible pane. Users can:
- Watch output in real-time
- Press `Ctrl+C` to interrupt
- Take over the terminal
- Run their own commands after

## AI Agent Path

When running from non-interactive shells (like AI agents), use the full path:
```bash
~/bin/tcmd -p 2:1.3 'command'
```

Users can use the alias `tcmd` after adding to `~/.zshrc`:
```bash
alias tcmd="~/bin/tcmd"
```

## Command Safety

Commands are base64-encoded before execution, avoiding all shell escaping issues. Supports:
- Pipes (`|`)
- AND/OR (`&&`, `||`)
- Quotes (nested `"`, `'`)
- Loops (`for`, `while`)
- Redirects (`>`, `<`)
- Heredocs (`<<EOF`)
- Multiline scripts
- Unicode and special characters
- Binary data

**Note:** Process substitution `<()` requires `bash -c "..."` wrapper (uses `sh` by default).

## Common Patterns

### Development Server
```bash
~/bin/tcmd -p 2:1.3 'cd ~/project && npm run dev'
# User can see server logs and Ctrl+C to stop
```

### Build and Test
```bash
~/bin/tcmd -p 2:1.3 -t 120s 'npm run build && npm test'
```

### Interactive Programs
```bash
~/bin/tcmd -p 2:1.3 'vim config.yml'
# User can take over vim session
```

### Quick Check
```bash
~/bin/tcmd -p 2:1.3 'pwd && git status'
```

## Direct Tmux Commands

For operations beyond command execution:

```bash
# Send keys directly (no output capture)
tmux send-keys -t 2:1.3 'command' Enter

# Capture pane content
tmux capture-pane -t 2:1.3 -p

# Create new pane
tmux split-window -t 2:1 -h

# Select pane
tmux select-pane -t 2:1.3

# Kill pane
tmux kill-pane -t 2:1.3
```

## Pane Border Status

Pane numbers are displayed in the border when configured in `~/.tmux.conf`:
```
set -g pane-border-status top
set -g pane-border-format " #{pane_index}: #{pane_current_command} "
```

This shows pane numbers at all times, making it easy to identify targets.
