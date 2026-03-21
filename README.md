# Configs Backup

This repository stores personal terminal and editor configuration backups.

## Contents

- `tmux/` - tmux configuration with TPM plugins, session persistence, and SessionX session management
- `wezterm/` - WezTerm configuration tuned for a tmux-first workflow with the tab bar disabled
- `helix/` - Helix editor configuration files
- `waybar/` - Waybar configuration files

## Files

- `tmux/.tmux.conf` - main tmux config backup
- `wezterm/.wezterm.lua` - hidden-file WezTerm config backup
- `wezterm/wezterm.lua` - plain filename copy of the WezTerm config
- `helix/` - Helix editor configuration files
- `waybar/` - Waybar configuration files

## Usage

Copy the configs you want into their target locations:

```bash
cp tmux/.tmux.conf ~/.tmux.conf
cp wezterm/.wezterm.lua ~/.wezterm.lua
cp -r helix/* ~/.config/helix/
cp -r waybar/* ~/.config/waybar/
```
