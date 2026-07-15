#!/usr/bin/env bash
# Copy what is installed on the system back to the repository (backup).
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

# Klassy: user config only (official presets remain in the package)
if [[ -f "$HOME/.config/klassy/klassyrc" ]]; then
  sed '/^LookAndFeelSet=/d' "$HOME/.config/klassy/klassyrc" > "$ROOT/klassy/klassyrc"
fi

# Panel Colorizer: presets and configurations
if [[ -d "$HOME/.config/panel-colorizer" ]]; then
  mkdir -p "$ROOT/panel-colorizer"
  rsync -a --delete "$HOME/.config/panel-colorizer/" "$ROOT/panel-colorizer/" || true
fi

echo "Repository updated from the system: $ROOT"
