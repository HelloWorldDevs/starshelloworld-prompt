#!/bin/bash

set -e

echo "🚀 Installing Starship prompt..."

# 1. Ensure Starship is installed via Homebrew
if ! command -v starship &>/dev/null; then
  echo "📦 Installing Starship..."
  brew install starship
else
  echo "✅ Starship already installed."
fi

# 2. Copy starship.toml config
mkdir -p ~/.config
cp "$(dirname "$0")/starship.toml" ~/.config/starship.toml
echo "✅ Copied starship.toml to ~/.config"

# 3. Add to .zshrc if missing
if ! grep -q 'eval "$(starship init zsh)"' ~/.zshrc; then
  echo 'eval "$(starship init zsh)"' >> ~/.zshrc
  echo "✅ Added Starship init to ~/.zshrc"
else
  echo "ℹ️  Starship already initialized in .zshrc"
fi

# 4. Install Nerd Font (FiraCode)
echo "🔤 Checking for Nerd Font..."

NERD_FONT_NAME="FiraCode"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
FONT_DIR="$HOME/Library/Fonts"

if ! fc-list | grep -i "$NERD_FONT_NAME" &>/dev/null; then
  echo "📥 Downloading FiraCode Nerd Font..."
  curl -LO "$FONT_URL"
  unzip -o FiraCode.zip -d "$FONT_DIR"
  rm FiraCode.zip
  echo "✅ Installed FiraCode Nerd Font to $FONT_DIR"
else
  echo "✅ Nerd Font already installed."
fi

echo
echo "🎨 Please set your terminal font to 'FiraCode Nerd Font' manually in:"
echo "   iTerm2 → Preferences → Profiles → Text → Font"
echo "   or Terminal.app → Preferences → Profiles → Text → Font"

echo "✅ All done. Open a new terminal or run: source ~/.zshrc"