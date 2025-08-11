#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1) Homebrew (если нет)
if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # добавить brew в PATH для текущей сессии
  if [[ -d "/opt/homebrew/bin" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# 2) Пакеты
brew bundle --file="$REPO_ROOT/Brewfile"

# 3) Резервная копия старого конфигура
if [ -e "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
  echo "Backing up existing ~/.config/nvim to ~/.config/nvim.backup.$(date +%s)"
  mv "$HOME/.config/nvim" "$HOME/.config/nvim.backup.$(date +%s)"
fi

# 4) Симлинки через stow
mkdir -p "$HOME/.config"
stow -v -R -t "$HOME" nvim

# 5) Headless установка плагинов
"$REPO_ROOT/scripts/sync_nvim_headless.sh"

echo "✔ Neovim готов. Запускай: nvim"

