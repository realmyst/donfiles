#!/usr/bin/env bash
set -euo pipefail

# Пытаемся синхронизировать для популярных менеджеров плагинов
if nvim --headless "+Lazy! sync" "+qa" >/dev/null 2>&1; then
  exit 0
fi

if nvim --headless "+PackerSync" "+qa" >/dev/null 2>&1; then
  exit 0
fi

# Если используешь Paq:
if nvim --headless "+PaqInstall" "+qa" >/dev/null 2>&1; then
  exit 0
fi

# Fallback: просто откатиться, если никакой не сработал
echo "WARN: Не удалось выполнить headless sync (ни Lazy, ни Packer, ни Paq). Проверь менеджер плагинов." >&2
exit 0

