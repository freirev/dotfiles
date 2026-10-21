#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Verify core CLI dependencies
for cmd in git curl vim zsh; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Error: Required command '$cmd' is not installed."
    exit 1
  fi
done

# Explicitly link $HOME dotfiles
echo "Linking core dotfiles to $HOME..."
for file in .zshrc .vimrc .latexmkrc; do
  ln -sfv "$DOTFILES_DIR/$file" "$HOME/$file"
done

# Configure Zathura unconditionally
echo "Configuring Zathura..."
mkdir -p "$HOME/.config/zathura"
ln -sfv "$DOTFILES_DIR/zathurarc" "$HOME/.config/zathura/zathurarc"

# Install zsh-autosuggestions
AUTOSUGGEST_DIR="$HOME/.zsh/zsh-autosuggestions"
if [ ! -d "$AUTOSUGGEST_DIR" ]; then
  echo "Installing zsh-autosuggestions..."
  git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions "$AUTOSUGGEST_DIR"
fi

# Install vim-plug and Vim plugins
if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
  echo "Installing vim-plug..."
  curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
echo "Updating Vim plugins..."
vim -es -u "$HOME/.vimrc" -i NONE -c "PlugInstall --sync" -c "qa" || true

# Ensure SSH config permissions
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
if [ ! -f "$HOME/.ssh/config" ]; then
  touch "$HOME/.ssh/config"
  chmod 600 "$HOME/.ssh/config"
fi

# Configure Git defaults
git config --global pull.rebase false
if [ -z "$(git config --global user.name)" ]; then
  read -p "Enter git user.name: " USER_NAME
  git config --global user.name "$USER_NAME"
fi
if [ -z "$(git config --global user.email)" ]; then
  read -p "Enter git user.email: " USER_EMAIL
  git config --global user.email "$USER_EMAIL"
fi

# Final shell check
if [[ "$SHELL" != *"zsh"* ]]; then
  echo "Note: Your default shell is $SHELL. To switch to zsh, run: chsh -s \$(which zsh)"
fi

echo "Install complete!"
