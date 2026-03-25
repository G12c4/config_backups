# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc
export GOPATH="$HOME/go"
export PATH="$PATH:$HOME/go/bin"
export PATH="$HOME/.cargo/bin:$PATH"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv >/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi
if command -v direnv >/dev/null 2>&1; then
    eval "$(direnv hook bash)"
fi
if [[ $(uname -s) == "Linux" ]]; then
    export GDK_BACKEND=x11
fi

# Set window title and prompt with full working directory
PS1='\[\033]0;\u@\h:\w\007\]\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\n❯ '

export PATH=$HOME/.local/share/bin:$PATH
alias ls='eza --long --header --icons --git --group-directories-first --no-permissions --no-user'
alias tree='eza --tree --level=2 --long --header --icons --git --group-directories-first --no-permissions --no-user'

# opencode
export PATH="$HOME/.opencode/bin:$PATH"
alias op=opencode
alias k=kubectl
if [[ -x "$HOME/Documents/golang/pyote-cli/bin/pyote" ]]; then
    alias pyote="$HOME/Documents/golang/pyote-cli/bin/pyote"
fi

if command -v brew >/dev/null 2>&1; then
    eval "$(brew shellenv bash)"
fi
if [[ -x "$HOME/Documents/bash/git/git-sync-rebase.sh" ]]; then
    alias gsync="$HOME/Documents/bash/git/git-sync-rebase.sh"
fi
export PATH="$HOME/go/bin:$PATH"

# ---- Zoxide (better cd) ----
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init bash)"
fi

# ---- History setup ----
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth
shopt -s histappend

alias t='tmux'

# ---- Atuin (better history with up arrow) ----
if command -v atuin >/dev/null 2>&1; then
    eval "$(atuin init bash)"

    __atuin_capture_precmd() {
        local exit_code=$?

        local previous_command
        previous_command=$(
            export LC_ALL=C HISTTIMEFORMAT=''
            builtin history 1 | sed '1 s/^ *[0-9][0-9]*[* ] //'
        )

        case $previous_command in
            ''|__atuin_*|__bp_*|trap*|history*|prompt_command* )
                return $exit_code ;;
        esac

        if [[ ${__ATUIN_CAPTURE_LAST:-} != "$previous_command" ]]; then
            local history_id
            history_id=$(ATUIN_LOG=error atuin history start -- "$previous_command" 2>/dev/null)
            if [[ -n $history_id ]]; then
                ATUIN_LOG=error atuin history end --exit "$exit_code" -- "$history_id" >/dev/null 2>&1
                __ATUIN_CAPTURE_LAST=$previous_command
                export __ATUIN_CAPTURE_LAST
            fi
        fi

        return $exit_code
    }

    case ${PROMPT_COMMAND:-} in
        *"__atuin_capture_precmd"*) ;;
        '') PROMPT_COMMAND='__atuin_capture_precmd' ;;
        *) PROMPT_COMMAND="__atuin_capture_precmd; $PROMPT_COMMAND" ;;
    esac
fi
