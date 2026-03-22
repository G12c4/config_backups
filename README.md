# Configs Backup

This repository is the source of truth for personal terminal and editor configs, managed with GNU Stow.

## Contents

- `tmux/` - tmux configuration with TPM plugins, session persistence, and SessionX session management
- `wezterm/` - WezTerm configuration tuned for a tmux-first workflow with the tab bar disabled
- `zsh/` - Zsh shell configuration
- `bash/` - Bash shell configuration
- `atuin/` - Atuin search and history filtering config under `.config/atuin/`
- `navi/` - Navi cheatsheets under `.local/share/navi/cheats/`
- `nvim/` - Neovim config under `.config/nvim/`
- `helix/` - Helix editor configuration files under `.config/helix/`
- `opencode/` - OpenCode config and custom skills under `.config/opencode/`
- `tmuxifier/` - Tmuxifier layout files under `.tmuxifier/`
- `waybar/` - Waybar configuration files under `.config/waybar/`
- `docs/` - reference notes that should not be stowed into `$HOME`
- `scripts/` - helper scripts that should not be stowed into `$HOME`

## Files

- `tmux/.tmux.conf` - main tmux config
- `tmux/.tmux-cheatsheet.txt` - tmux keybinding cheat sheet
- `tmux/.tmux/plugins/tmux-sessionx/` - custom SessionX plugin patches, including the `?` help screen override
- `wezterm/.wezterm.lua` - WezTerm config
- `zsh/.zshrc` - Zsh shell config
- `bash/.bashrc` and `bash/.bash_profile` - Bash shell configs
- `atuin/.config/atuin/config.toml` - Atuin config
- `navi/.local/share/navi/cheats/` - Navi cheatsheets
- `nvim/.config/nvim/` - Neovim config
- `helix/.config/helix/` - Helix editor configuration files
- `opencode/.config/opencode/` - OpenCode config and skills
- `tmuxifier/.tmuxifier/layouts/` - Tmuxifier custom layouts
- `waybar/.config/waybar/` - Waybar configuration files

## Usage

Install GNU Stow:

```bash
brew install stow
```

From this repository, stow the packages you want into your home directory:

```bash
cd ~/Documents/config_backups
stow -t "$HOME" tmux wezterm helix opencode tmuxifier

# or stow everything currently tracked for macOS terminal workflow
stow -t "$HOME" tmux wezterm zsh bash atuin navi helix opencode tmuxifier

# include Neovim too
stow -t "$HOME" tmux wezterm zsh bash atuin navi nvim helix opencode tmuxifier
```

Remove symlinks for a package:

```bash
cd ~/Documents/config_backups
stow -D -t "$HOME" tmux
```

Preview changes without modifying anything:

```bash
cd ~/Documents/config_backups
stow -n -v -t "$HOME" tmux wezterm helix opencode tmuxifier

# expanded dry run
stow -n -v -t "$HOME" tmux wezterm zsh bash atuin navi helix opencode tmuxifier

stow -n -v -t "$HOME" tmux wezterm zsh bash atuin navi nvim helix opencode tmuxifier
```

## SessionX Patch Restore

The tmux package includes a local SessionX plugin customization that changes `?` to show a help screen and moves preview toggle to `Alt-p`.

If TPM reinstalls or updates SessionX, restow the `tmux` package to restore the patched files:

```bash
cd ~/Documents/config_backups
stow -R -t "$HOME" tmux
tmux source-file ~/.tmux.conf
```
