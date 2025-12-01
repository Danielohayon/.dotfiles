#!/bin/bash

# Setup script for new Mac
# Run with: bash setup_new_mac.sh

set -e

DOTFILES_DIR="$HOME/Documents/Projects/.dotfiles"

echo "=== Setting up new Mac ==="

# ============================================
# Install Homebrew if not installed
# ============================================
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add brew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    echo "Homebrew already installed"
fi

# ============================================
# Install packages
# ============================================
echo "Installing packages..."

brew install neovim
brew install ripgrep
brew install fzf
brew install fd
brew install eza
brew install zoxide
brew install lazygit
brew install kubectl
brew install tmux
brew install node
brew install watch

# chatgpt-cli
brew tap kardolus/chatgpt-cli && brew install chatgpt-cli

# Python LSP
npm install -g pyright

# ============================================
# Setup fzf key bindings and completion
# ============================================
echo "Setting up fzf..."
$(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish

# ============================================
# Create config directories
# ============================================
echo "Creating config directories..."
mkdir -p ~/.config
mkdir -p ~/.chatgpt-cli

# ============================================
# Symlink dotfiles
# ============================================
echo "Symlinking dotfiles..."

# Remove existing configs if they exist
rm -rf ~/.config/nvim
rm -f ~/.zshrc
rm -f ~/.tmux.conf

# Create symlinks
ln -s "$DOTFILES_DIR/.config/nvim" ~/.config/nvim
ln -sf "$DOTFILES_DIR/.zshrc" ~/.zshrc
ln -sf "$DOTFILES_DIR/.tmux.conf" ~/.tmux.conf

# ============================================
# Install tmux plugin manager (TPM)
# ============================================
if [ ! -d ~/.tmux/plugins/tpm ]; then
    echo "Installing tmux plugin manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# ============================================
# Done
# ============================================
echo ""
echo "=== Setup complete! ==="
echo ""
echo "Next steps:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Open tmux and press prefix + I to install tmux plugins"
echo "  3. Open nvim to let lazy.nvim install plugins"
echo "  4. Set your API keys in ~/.zshrc if needed"
