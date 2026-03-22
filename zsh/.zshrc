eval "$(/opt/homebrew/bin/brew shellenv)"
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

. "$HOME/.local/bin/env"
export PATH="$HOME/.local/bin:$PATH"

# bun completions
[ -s "/Users/josip/.bun/_bun" ] && source "/Users/josip/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
alias ls='eza --long --header --icons --git --group-directories-first --no-permissions --no-user'
alias tree='eza --tree --level=2 --long --header --icons --git --group-directories-first --no-permissions --no-user'
alias op='opencode'
update_dotfiles_repo() {
  local repo="$HOME/Documents/config_backups"
  git -C "$repo" add . && \
    git -C "$repo" commit -m "Update dotfiles $(date '+%Y-%m-%d %H:%M:%S')" && \
    git -C "$repo" push
}
alias update-dotfiles-repo='update_dotfiles_repo'

# Added by Antigravity
export PATH="/Users/josip/.antigravity/antigravity/bin:$PATH"

# Nix
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

# Opencode
export EDITOR=hx

# Prompt - show full path with command on new line
PROMPT='%n@%M:%d
❯ '

# History search - type prefix + Up/Down to search matching commands
autoload -U up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search    # Up arrow
bindkey "^[[B" down-line-or-beginning-search  # Down arrow

# History settings
HISTSIZE=10000
SAVEHIST=20000
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY

zshaddhistory() {
  local cmd=${1%%$'\n'}
  [[ $cmd =~ '^(ls|cd)([[:space:]]|$)' ]] && return 1
  return 0
}

alias t="tmux"
alias ta="tmux attach"
alias tcmd="~/bin/tcmd"
alias tmx="tmuxifier"

# Tmuxifier
export PATH="$HOME/.tmuxifier/bin:$PATH"
eval "$(tmuxifier init -)"

# Create new tmux session with default layout
tmx-new() {
  local name="${1:-$(basename "$PWD")}"
  TMUXIFIER_SESSION_NAME="$name" tmuxifier load-session default
}

. "$HOME/.atuin/bin/env"

if command -v atuin >/dev/null 2>&1; then
  atuin daemon status >/dev/null 2>&1 || atuin daemon restart >/dev/null 2>&1
fi

eval "$(atuin init zsh)"

if command -v navi >/dev/null 2>&1; then
  eval "$(navi widget zsh)"
  bindkey '^g' _navi_widget
fi
