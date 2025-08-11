#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if command -v apt >/dev/null 2>&1; then
  sudo apt update
  sudo apt install -y git neovim stow ripgrep fd-find fzf curl
  # fd в Debian называется fdfind — сделаем алиас, если нужно
  if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
  fi
elif command -v pacman >/dev/null 2>&1; then
  sudo pacman -Syu --noconfirm git neovim stow ripgrep fd fzf curl
elif command -v dnf >/dev/null 2>&1; then
  sudo dnf install -y git neovim stow ripgrep fd-find fzf curl
else
  echo "Install deps manually: git, neovim, stow, ripgrep, fd, fzf"
fi

# Резервная копия, если нужно
if [ -e "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
  echo "Backing up existing ~/.config/nvim to ~/.config/nvim.backup.$(date +%s)"
  mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup.$(date +%s)"
fi

mkdir -p "$HOME/.config"
stow -v -R -t "$HOME" nvim

"$REPO_ROOT/scripts/sync_nvim_headless.sh"

echo "✔ Neovim готов. Запускай: nvim"
