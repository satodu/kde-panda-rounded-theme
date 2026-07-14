#!/usr/bin/env bash
# Instala Panda Rounded (Plasma + cores + Kvantum + Look-and-Feel + Klassy) no usuário atual.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODE="${1:-both}"  # dark | light | both

install_dark() {
  echo "→ Plasma Style (escuro)"
  mkdir -p "$HOME/.local/share/plasma/desktoptheme"
  rsync -a --delete "$ROOT/plasma/desktoptheme/Panda-theme/" \
    "$HOME/.local/share/plasma/desktoptheme/Panda-theme/"

  echo "→ Cores (Panda Color)"
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
  echo "→ Plasma Style (claro)"
  mkdir -p "$HOME/.local/share/plasma/desktoptheme"
  rsync -a --delete "$ROOT/plasma/desktoptheme/Panda-theme-light/" \
    "$HOME/.local/share/plasma/desktoptheme/Panda-theme-light/"

  echo "→ Cores (Panda Light)"
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
  echo "→ Klassy (config da decoração)"
  if [[ ! -e /usr/lib/qt6/plugins/org.kde.kdecoration2/org.kde.klassy.so ]] \
     && [[ ! -e /usr/lib/qt/plugins/org.kde.kdecoration2/org.kde.klassy.so ]]; then
    echo "  ⚠ Klassy não detectado. Instale antes (ex.: AUR klassy-bin)."
  fi
  mkdir -p "$HOME/.config/klassy"
  cp "$ROOT/klassy/klassyrc" "$HOME/.config/klassy/klassyrc"
}

set_kvantum() {
  local theme="$1"
  mkdir -p "$HOME/.config/Kvantum"
  printf '[General]\ntheme=%s\n' "$theme" > "$HOME/.config/Kvantum/kvantum.kvconfig"
  echo "→ Kvantum ativo: $theme"
}

case "$MODE" in
  dark)
    install_dark
    install_klassy
    set_kvantum Panda
    ;;
  light)
    install_light
    install_klassy
    set_kvantum PandaLight
    ;;
  both)
    install_dark
    install_light
    install_klassy
    set_kvantum Panda
    ;;
  *)
    echo "Uso: $0 [dark|light|both]"
    exit 1
    ;;
esac

echo
echo "Pronto. Próximos passos manuais:"
echo "  1. Configurações → Aparência → Temas Globais → Panda Rounded (ou Light)"
echo "  2. Klassy instalado (AUR: klassy-bin) — Decoração de janelas = Klassy"
echo "  3. Ícones: Reversal (não vem neste repo) — ex. Reversal-purple"
echo "  4. plasmashell --replace &   # se necessário"
