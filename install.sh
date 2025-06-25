#!/bin/bash
# install.sh — CLI-Style installer

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

echo "🎨 Adding banner and prompt to .bashrc..."

cat << 'EOF' >> ~/.bashrc

# ==== CLI-STYLE CUSTOMIZATION ====
clear
figlet "Welcome!" | lolcat
neofetch

# Colorful prompt: user@host:~$
PS1='\[\e[1;35m\]\u@\h \[\e[1;36m\]\w\[\e[0m\]\n$ '

# ==== END CLI-STYLE ====
EOF

echo "✅ Done! Launch a new terminal or run 'source ~/.bashrc' to see your style in action."
