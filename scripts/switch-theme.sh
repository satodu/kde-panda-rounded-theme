#!/usr/bin/env bash
# Switch between Panda Rounded dark and light (Plasma 6).
# Usage: switch-theme.sh [dark|light|toggle]
set -euo pipefail

MODE="${1:-toggle}"

LOOKANDFEEL_DARK="com.github.satodu.panda.desktop"
LOOKANDFEEL_LIGHT="com.github.satodu.panda-light.desktop"
KVANTUM_DARK="Panda"
KVANTUM_LIGHT="PandaLight"
COLORS_DARK="Panda Color"
COLORS_LIGHT="Panda Light"
PLASMA_DARK="Panda-theme"
PLASMA_LIGHT="Panda-theme-light"
ICONS_DARK="Reversal-purple-dark"
ICONS_LIGHT="Reversal-purple"
ICONS_FALLBACK="Reversal-purple"
KONSOLE_DARK="Panda.profile"
KONSOLE_LIGHT="Panda Light.profile"

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing command: $1" >&2
    exit 1
  }
}

current_mode() {
  local scheme
  scheme="$(kreadconfig6 --file kdeglobals --group General --key ColorScheme 2>/dev/null || true)"
  case "$scheme" in
    "Panda Light"|"PandaLight") echo light ;;
    "Panda Color"|"PandaColor"|"Panda") echo dark ;;
    *)
      local kv
      kv="$(kreadconfig6 --file Kvantum/kvantum.kvconfig --group General --key theme 2>/dev/null || true)"
      case "$kv" in
        PandaLight) echo light ;;
        Panda) echo dark ;;
        *) echo dark ;;
      esac
      ;;
  esac
}

set_kvantum() {
  mkdir -p "$HOME/.config/Kvantum"
  printf '[General]\ntheme=%s\n' "$1" > "$HOME/.config/Kvantum/kvantum.kvconfig"
}

icon_theme_exists() {
  local name="$1"
  [[ -d "/usr/share/icons/$name" ]] \
    || [[ -d "$HOME/.local/share/icons/$name" ]] \
    || [[ -d "$HOME/.icons/$name" ]]
}

apply_icons() {
  local preferred="$1"
  local theme="$preferred"
  if ! icon_theme_exists "$theme"; then
    theme="$ICONS_FALLBACK"
  fi
  if ! icon_theme_exists "$theme"; then
    echo "→ Icons: skipped (Reversal not installed)"
    return 0
  fi
  if command -v plasma-apply-icontheme >/dev/null 2>&1; then
    plasma-apply-icontheme "$theme" >/dev/null
  else
    kwriteconfig6 --file kdeglobals --group Icons --key Theme "$theme"
  fi
  echo "→ Icons: $theme"
}

apply_mode() {
  local target="$1"
  local lookandfeel kvantum colors plasma icons konsole

  if [[ "$target" == light ]]; then
    lookandfeel="$LOOKANDFEEL_LIGHT"
    kvantum="$KVANTUM_LIGHT"
    colors="$COLORS_LIGHT"
    plasma="$PLASMA_LIGHT"
    icons="$ICONS_LIGHT"
    konsole="$KONSOLE_LIGHT"
  else
    lookandfeel="$LOOKANDFEEL_DARK"
    kvantum="$KVANTUM_DARK"
    colors="$COLORS_DARK"
    plasma="$PLASMA_DARK"
    icons="$ICONS_DARK"
    konsole="$KONSOLE_DARK"
  fi

  echo "Switching to Panda Rounded ($target)…"

  # Apply configurations without using plasma-apply-lookandfeel (which resets desktop widgets/layout)
  kwriteconfig6 --file kdeglobals --group KDE --key LookAndFeelPackage "$lookandfeel" || true
  kwriteconfig6 --file kdeglobals --group KDE --key widgetStyle "kvantum" || true
  kwriteconfig6 --file kcminputrc --group Mouse --key cursorTheme "breeze_cursors" || true
  kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key library "org.kde.klassy" || true
  kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key theme "Klassy" || true
  kwriteconfig6 --file konsolerc --group "Desktop Entry" --key DefaultProfile "$konsole" || true
  qdbus6 org.kde.KWin /KWin reconfigure >/dev/null 2>&1 || qdbus org.kde.KWin /KWin reconfigure >/dev/null 2>&1 || true
  echo "→ Global theme: $lookandfeel (layout preserved)"
  echo "→ Konsole profile: $konsole"

  if command -v plasma-apply-colorscheme >/dev/null 2>&1; then
    plasma-apply-colorscheme "$colors" >/dev/null || true
    echo "→ Colors: $colors"
  fi

  if command -v plasma-apply-desktoptheme >/dev/null 2>&1; then
    plasma-apply-desktoptheme "$plasma" >/dev/null || true
    echo "→ Plasma style: $plasma"
  fi

  set_kvantum "$kvantum"
  echo "→ Kvantum: $kvantum"

  apply_icons "$icons"

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



  echo "Done. Open apps may need a restart to fully pick up Kvantum."
}

case "$MODE" in
  dark|light)
    apply_mode "$MODE"
    ;;
  toggle)
    if [[ "$(current_mode)" == light ]]; then
      apply_mode dark
    else
      apply_mode light
    fi
    ;;
  *)
    echo "Usage: $0 [dark|light|toggle]"
    exit 1
    ;;
esac
