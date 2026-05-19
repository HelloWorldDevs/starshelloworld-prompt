#!/bin/bash
#
# starshelloworld-prompt installer
#   bash <(curl -s https://raw.githubusercontent.com/HelloWorldDevs/starshelloworld-prompt/main/install.sh)

set -e

REPO_RAW="https://raw.githubusercontent.com/HelloWorldDevs/starshelloworld-prompt/main"
CONFIG_DIR="$HOME/.config/starshelloworld"
BIN_DIR="$HOME/.local/bin"
ZSHRC="$HOME/.zshrc"

echo "🚀 Installing Hello World prompt..."

# 1. Ensure Starship is installed via Homebrew
if ! command -v starship &>/dev/null; then
  echo "📦 Installing Starship..."
  brew install starship
else
  echo "✅ Starship already installed."
fi

# 2. Install zsh enhancement plugins
echo "🔌 Installing zsh plugins (autosuggestions, syntax-highlighting)..."
for pkg in zsh-autosuggestions zsh-syntax-highlighting; do
  if brew list "$pkg" &>/dev/null; then
    echo "✅ $pkg already installed."
  else
    brew install "$pkg"
  fi
done

# 3. Download starship.toml from the repo
echo "🔧 Downloading starship.toml configuration..."
mkdir -p "$HOME/.config"
if [ -f "$HOME/.config/starship.toml" ]; then
  BACKUP="$HOME/.config/starship.toml.bak.$(date +%s)"
  cp "$HOME/.config/starship.toml" "$BACKUP"
  echo "ℹ️  Existing starship.toml backed up to $BACKUP"
fi
curl -fsSL "$REPO_RAW/starship.toml" -o "$HOME/.config/starship.toml"
echo "✅ Installed starship.toml to ~/.config"

# 4. Download shell enhancements + lando-hosts helper
echo "🐚 Installing shell enhancements + lando-hosts helper..."
mkdir -p "$CONFIG_DIR" "$BIN_DIR"
curl -fsSL "$REPO_RAW/helloworld.zsh" -o "$CONFIG_DIR/helloworld.zsh"
curl -fsSL "$REPO_RAW/lando-hosts"    -o "$BIN_DIR/lando-hosts"
chmod +x "$BIN_DIR/lando-hosts"
echo "✅ Installed helloworld.zsh and lando-hosts"

# 5. Wire up ~/.zshrc
touch "$ZSHRC"
if ! grep -q 'starship init zsh' "$ZSHRC"; then
  echo 'eval "$(starship init zsh)"' >> "$ZSHRC"
  echo "✅ Added Starship init to ~/.zshrc"
else
  echo "ℹ️  Starship already initialized in ~/.zshrc"
fi
if ! grep -q 'starshelloworld/helloworld.zsh' "$ZSHRC"; then
  echo 'source "$HOME/.config/starshelloworld/helloworld.zsh"' >> "$ZSHRC"
  echo "✅ Added shell enhancements to ~/.zshrc"
else
  echo "ℹ️  Shell enhancements already sourced in ~/.zshrc"
fi

# 6. Install Nerd Font (FiraCode)
echo "🔤 Checking for Nerd Font..."
FONT_DIR="$HOME/Library/Fonts"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
if ls "$FONT_DIR"/FiraCode*NerdFont*.ttf &>/dev/null; then
  echo "✅ FiraCode Nerd Font already installed."
else
  echo "📥 Downloading FiraCode Nerd Font..."
  TMP_ZIP="$(mktemp -t FiraCode).zip"
  curl -fsSL "$FONT_URL" -o "$TMP_ZIP"
  unzip -o "$TMP_ZIP" -d "$FONT_DIR" >/dev/null
  rm -f "$TMP_ZIP"
  echo "✅ Installed FiraCode Nerd Font to $FONT_DIR"
fi

echo
echo "🎨 Set your terminal font to 'FiraCode Nerd Font':"
echo "   iTerm2 → Settings → Profiles → Text → Font"
echo "🎯 In iTerm2 also enable word-nav keys:"
echo "   Settings → Profiles → Keys → Key Mappings → Presets → Natural Text Editing"
echo
echo "✅ All done. Open a new terminal or run: source ~/.zshrc"
