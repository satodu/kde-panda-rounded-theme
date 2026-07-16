#!/usr/bin/env bash
# Install Panda Rounded (Plasma + colors + Kvantum + Look-and-Feel + Klassy) for the current user.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODE="${1:-both}"  # dark | light | both

install_dark() {
  echo "→ Plasma Style (dark)"
  mkdir -p "$HOME/.local/share/plasma/desktoptheme"
  rsync -a --delete "$ROOT/plasma/desktoptheme/Panda-theme/" \
    "$HOME/.local/share/plasma/desktoptheme/Panda-theme/"

  echo "→ Colors (Panda Color)"
  mkdir -p "$HOME/.local/share/color-schemes"
  cp "$ROOT/color-schemes/Panda-Color.colors" \
    "$HOME/.local/share/color-schemes/Panda Color.colors"

  echo "→ Kvantum (Panda)"
  mkdir -p "$HOME/.config/Kvantum/Panda"
  rsync -a --delete "$ROOT/kvantum/Panda/" "$HOME/.config/Kvantum/Panda/"

  echo "→ Look-and-Feel (Panda Rounded)"
  mkdir -p "$HOME/.local/share/plasma/look-and-feel"
  rsync -a --delete "$ROOT/look-and-feel/com.github.satodu.panda.desktop/" \
    "$HOME/.local/share/plasma/look-and-feel/com.github.satodu.panda.desktop/"
}

install_light() {
  echo "→ Plasma Style (light)"
  mkdir -p "$HOME/.local/share/plasma/desktoptheme"
  rsync -a --delete "$ROOT/plasma/desktoptheme/Panda-theme-light/" \
    "$HOME/.local/share/plasma/desktoptheme/Panda-theme-light/"

  echo "→ Colors (Panda Light)"
  mkdir -p "$HOME/.local/share/color-schemes"
  cp "$ROOT/color-schemes/Panda-Light.colors" \
    "$HOME/.local/share/color-schemes/Panda Light.colors"

  echo "→ Kvantum (PandaLight)"
  mkdir -p "$HOME/.config/Kvantum/PandaLight"
  rsync -a --delete "$ROOT/kvantum/PandaLight/" "$HOME/.config/Kvantum/PandaLight/"

  echo "→ Look-and-Feel (Panda Rounded Light)"
  mkdir -p "$HOME/.local/share/plasma/look-and-feel"
  rsync -a --delete "$ROOT/look-and-feel/com.github.satodu.panda-light.desktop/" \
    "$HOME/.local/share/plasma/look-and-feel/com.github.satodu.panda-light.desktop/"
}

install_klassy() {
  echo "→ Klassy (window decoration config)"
  if [[ ! -e /usr/lib/qt6/plugins/org.kde.kdecoration2/org.kde.klassy.so ]] \
     && [[ ! -e /usr/lib/qt/plugins/org.kde.kdecoration2/org.kde.klassy.so ]]; then
    echo "  ⚠ Klassy not detected. Please install it first (e.g., AUR: klassy-bin)."
  fi
  mkdir -p "$HOME/.config/klassy"
  cp "$ROOT/klassy/klassyrc" "$HOME/.config/klassy/klassyrc"
}

install_panel_colorizer() {
  if [[ -d "$ROOT/panel-colorizer" ]]; then
    echo "→ Panel Colorizer (presets and configs)"
    mkdir -p "$HOME/.config/panel-colorizer"
    rsync -a --delete "$ROOT/panel-colorizer/" "$HOME/.config/panel-colorizer/"
  fi
}

install_konsole() {
  if [[ -d "$ROOT/konsole" ]]; then
    echo "→ Konsole (profiles and color schemes)"
    mkdir -p "$HOME/.local/share/konsole"
    cp -r "$ROOT/konsole/"* "$HOME/.local/share/konsole/"
  fi
}

install_reversal_icons() {
  echo "→ Reversal Icon Theme"
  # Check if a few representative color variations are installed to ensure the user has the full theme package
  if ([[ -d "$HOME/.local/share/icons/Reversal-purple" ]] || [[ -d "$HOME/.icons/Reversal-purple" ]] || [[ -d "/usr/share/icons/Reversal-purple" ]]) \
     && ([[ -d "$HOME/.local/share/icons/Reversal-blue" ]] || [[ -d "$HOME/.icons/Reversal-blue" ]] || [[ -d "/usr/share/icons/Reversal-blue" ]]) \
     && ([[ -d "$HOME/.local/share/icons/Reversal-red" ]] || [[ -d "$HOME/.icons/Reversal-red" ]] || [[ -d "/usr/share/icons/Reversal-red" ]]); then
    echo "  ✓ Reversal icon theme (all colors) is already installed."
    return 0
  fi

  echo "  Reversal color variations missing. Downloading and installing all color variations..."
  local temp_dir
  temp_dir=$(mktemp -d)
  if git clone --depth 1 https://github.com/yeyushengfan258/Reversal-icon-theme.git "$temp_dir"; then
    "$temp_dir/install.sh" -t all
  else
    echo "  ⚠ Failed to clone Reversal icon theme repository. Skipping icon installation."
  fi
  rm -rf "$temp_dir"
}

set_kvantum() {
  local theme="$1"
  mkdir -p "$HOME/.config/Kvantum"
  printf '[General]\ntheme=%s\n' "$theme" > "$HOME/.config/Kvantum/kvantum.kvconfig"
  echo "→ Active Kvantum theme: $theme"
}

case "$MODE" in
  dark)
    install_dark
    install_klassy
    install_panel_colorizer
    install_konsole
    install_reversal_icons
    set_kvantum Panda
    ;;
  light)
    install_light
    install_klassy
    install_panel_colorizer
    install_konsole
    install_reversal_icons
    set_kvantum PandaLight
    ;;
  both)
    install_dark
    install_light
    install_klassy
    install_panel_colorizer
    install_konsole
    install_reversal_icons
    set_kvantum Panda
    ;;
  *)
    echo "Usage: $0 [dark|light|both]"
    exit 1
    ;;
esac

echo
echo "→ Clearing Plasma theme cache..."
rm -f "$HOME/.cache/plasma-theme-"* "$HOME/.cache/plasma_theme_"* 2>/dev/null || true

echo "→ Restarting plasmashell to update context menus..."
if systemctl --user is-active plasma-plasmashell.service >/dev/null 2>&1; then
  systemctl --user restart plasma-plasmashell.service
else
  kquitapp6 plasmashell 2>/dev/null || killall plasmashell 2>/dev/null || true
  sleep 1
  kstart6 plasmashell >/dev/null 2>&1 &
fi



echo
echo "Done. Next manual steps:"
echo "  1. Settings → Appearance → Global Themes → Panda Rounded (or Light)"
echo "  2. Klassy installed (AUR: klassy-bin) — Window Decorations = Klassy"
echo "  3. Icons: Reversal (not included in this repo) — e.g., Reversal-purple"
