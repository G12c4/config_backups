# Configs Backup

This repository stores personal terminal and editor configuration backups.

## Contents

- `tmux/` - tmux configuration with TPM plugins, session persistence, and SessionX session management
- `wezterm/` - WezTerm configuration tuned for a tmux-first workflow with the tab bar disabled
- `helix/` - Helix editor configuration files
- `waybar/` - Waybar configuration files

## Files

- `tmux/.tmux.conf` - main tmux config backup
- `tmux/plugins/tmux-sessionx/` - local backup of custom SessionX plugin patches, including the `?` help screen override
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

## SessionX Patch Restore

The tmux backup includes a local SessionX plugin customization that changes `?` to show a help screen and moves preview toggle to `Alt-p`.

After TPM installs or updates SessionX, restore the patched files with:

```bash
cp tmux/plugins/tmux-sessionx/sessionx.tmux ~/.tmux/plugins/tmux-sessionx/sessionx.tmux
cp tmux/plugins/tmux-sessionx/scripts/help.sh ~/.tmux/plugins/tmux-sessionx/scripts/help.sh
chmod +x ~/.tmux/plugins/tmux-sessionx/scripts/help.sh
tmux source-file ~/.tmux.conf
```
