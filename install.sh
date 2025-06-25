#!/bin/bash
# install.sh — CLI-Style installer with theme selector

set -e

echo "🔍 Detecting environment..."

# Detect package manager and sudo usage
if command -v termux-info >/dev/null 2>&1; then
    PKG_CMD="pkg"
    SUDO=""
else
    PKG_CMD="apt"
    SUDO="sudo"
fi

echo "✅ Using package manager: $PKG_CMD"

echo "📦 Installing required packages..."
$SUDO $PKG_CMD update -y
$SUDO $PKG_CMD install -y figlet ruby neofetch

if ! command -v lolcat >/dev/null 2>&1; then
    echo "🌈 Installing lolcat (via Ruby)..."
    $SUDO gem install lolcat
fi

echo "💾 Backing up current .bashrc..."
cp -f ~/.bashrc ~/.bashrc.backup

# =========================
# 🎨 Theme Selector
# =========================
echo ""
echo "Choose your CLI prompt style:"
echo "1) Minimal   → \u@\h \$"
echo "2) Classic   → \u@\h:\w \$ (with color)"
echo "3) Fancy     → Multiline, bold, full color"
echo ""

read -p "Enter theme number (1-3): " THEME_CHOICE

case $THEME_CHOICE in
  1)
    PROMPT='PS1="\u@\h \$ "'
    ;;
  2)
    PROMPT='PS1="\[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\] \$ "'
    ;;
  3)
    PROMPT='PS1="\[\e[1;35m\]\u@\h \[\e[1;36m\]\w\[\e[0m\]\n\$ "'
    ;;
  *)
    echo "❌ Invalid choice. Using default (Fancy)."
    PROMPT='PS1="\[\e[1;35m\]\u@\h \[\e[1;36m\]\w\[\e[0m\]\n\$ "'
    ;;
esac

# =========================
# Append to .bashrc
# =========================
echo "🎨 Applying CLI style..."

cat <<EOF >> ~/.bashrc

# ==== CLI-STYLE CUSTOMIZATION ====
clear
figlet "Welcome!" | lolcat
neofetch

$PROMPT

# ==== END CLI-STYLE ====
EOF

echo "✅ Style applied! Launch a new terminal or run: source ~/.bashrc"
