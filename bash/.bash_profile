# Bash completions
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

# WezTerm CLI completions
if command -v wezterm &>/dev/null; then
    eval "$(wezterm shell-completion --shell bash)"
fi

# History settings
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth:erasedups
shopt -s histappend

# Up/Down arrows search history based on what you've typed
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# Ctrl+R for fuzzy history search (optional but powerful)
bind '"\C-r": reverse-search-history'

. "$HOME/.atuin/bin/env"
