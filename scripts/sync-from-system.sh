#!/usr/bin/env bash
# Copia o que está instalado no sistema de volta para o repositório (backup).
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

rsync -a --delete --exclude='.git' \
  "$HOME/.local/share/plasma/desktoptheme/Panda-theme/" \
  "$ROOT/plasma/desktoptheme/Panda-theme/" || true

rsync -a --delete \
  "$HOME/.local/share/plasma/desktoptheme/Panda-theme-light/" \
  "$ROOT/plasma/desktoptheme/Panda-theme-light/" || true

cp "$HOME/.local/share/color-schemes/Panda Color.colors" \
  "$ROOT/color-schemes/Panda-Color.colors" 2>/dev/null || true
cp "$HOME/.local/share/color-schemes/Panda Light.colors" \
  "$ROOT/color-schemes/Panda-Light.colors" 2>/dev/null || true

rsync -a --delete "$HOME/.config/Kvantum/Panda/" "$ROOT/kvantum/Panda/" || true
rsync -a --delete "$HOME/.config/Kvantum/PandaLight/" "$ROOT/kvantum/PandaLight/" || true

echo "Repo atualizado a partir do sistema: $ROOT"
