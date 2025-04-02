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

echo "✅ All done. Open a new terminal or run: source ~/.zshrc"