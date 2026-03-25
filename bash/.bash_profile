# Bash completions
if command -v brew >/dev/null 2>&1; then
    BREW_PREFIX=$(brew --prefix 2>/dev/null)
    if [[ -n "$BREW_PREFIX" && -r "$BREW_PREFIX/etc/profile.d/bash_completion.sh" ]]; then
        . "$BREW_PREFIX/etc/profile.d/bash_completion.sh"
    fi
fi

# WezTerm CLI completions
if command -v wezterm &>/dev/null; then
    eval "$(wezterm shell-completion --shell bash)"
fi

# History settings
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth:erasedups
shopt -s histappend

if [[ -f ~/.bashrc ]]; then
    . ~/.bashrc
fi
