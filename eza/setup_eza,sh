#!/bin/bash

# --- 1. DETECT OS & INSTALL EZA ---
echo "🔍 Detecting Operating System..."
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="MacOS"
fi

echo "📦 Installing eza for $OS..."

if [[ "$OS" == "Ubuntu" ]] || [[ "$OS" == "Debian GNU/Linux" ]]; then
    sudo apt update && sudo apt install -y gpg
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt update
    sudo apt install -y eza

elif [[ "$OS" == "Fedora Linux" ]]; then
    sudo dnf install -y eza

elif [[ "$OS" == "Arch Linux" ]]; then
    sudo pacman -S --noconfirm eza

elif [[ "$OS" == "MacOS" ]]; then
    if ! command -v brew &> /dev/null; then
        echo "❌ Homebrew is required on macOS."
        exit 1
    fi
    brew install eza
else
    echo "❌ OS not automatically supported. Please install eza manually."
    exit 1
fi

# --- 2. INJECT YOUR CUSTOM CONFIG ---
# Detect shell configuration file
if [[ "$SHELL" == */zsh ]]; then
    CONFIG_FILE="$HOME/.zshrc"
else
    CONFIG_FILE="$HOME/.bashrc"
fi

echo "⚙️  Configuring aliases in $CONFIG_FILE..."

# Create a variable with your exact preferences
read -r -d '' MY_ALIASES << EOM

# --- CUSTOM EZA SETUP ---
# Standard list view
alias ls='eza --long --header --icons --git --group-directories-first --no-permissions --no-user'

# Tree view (2 levels deep)
alias tree='eza --tree --level=2 --long --header --icons --git --group-directories-first --no-permissions --no-user'
# ------------------------
EOM

# Check if aliases already exist to prevent duplicates
if grep -q "CUSTOM EZA SETUP" "$CONFIG_FILE"; then
    echo "⚠️  Configuration already found in $CONFIG_FILE. Skipping injection."
else
    # Backup the file first
    cp "$CONFIG_FILE" "${CONFIG_FILE}.bak"
    echo "💾 Backup created at ${CONFIG_FILE}.bak"
    
    # Append aliases
    echo "$MY_ALIASES" >> "$CONFIG_FILE"
    echo "✅ Aliases added successfully."
fi

echo "🚀 Setup complete! Restart your terminal or run: source $CONFIG_FILE"
