#!/bin/bash
# uninstall.sh — removes CLI-Style and restores original .bashrc

set -e

echo "🔄 Starting CLI-Style uninstall..."

# Check for backup
if [ -f ~/.bashrc.backup ]; then
    echo "💾 Restoring original .bashrc..."
    cp -f ~/.bashrc.backup ~/.bashrc
else
    echo "⚠️ No .bashrc.backup found. Skipping restore."
fi

# Ask if user wants to remove tools
read -p "🧹 Do you want to remove figlet, neofetch, and lolcat? (y/N): " REMOVE_TOOLS

if [[ "$REMOVE_TOOLS" =~ ^[Yy]$ ]]; then
    echo "🔍 Detecting system..."

    if command -v termux-info >/dev/null 2>&1; then
        PKG_CMD="pkg"
        SUDO=""
    else
        PKG_CMD="apt"
        SUDO="sudo"
    fi

    echo "🧼 Removing packages..."
    $SUDO $PKG_CMD remove -y figlet neofetch ruby || true

    if gem list lolcat -i >/dev/null 2>&1; then
        echo "🗑 Uninstalling lolcat (Ruby gem)..."
        $SUDO gem uninstall -aIx lolcat || true
    fi
fi

echo "✅ CLI-Style uninstalled. You may restart your terminal or run:"
echo "   source ~/.bashrc"
