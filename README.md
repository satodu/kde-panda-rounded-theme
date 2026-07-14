# Panda Rounded Theme

Complete package (dark + light) for KDE Plasma 6:

| Component | Dark | Light |
|-----------|------|-------|
| Plasma Style | `Panda-theme` | `Panda-theme-light` |
| Colors | `Panda Color` | `Panda Light` |
| Kvantum | `Panda` | `PandaLight` |
| Global Theme | `Panda Rounded` | `Panda Rounded Light` |
| Decoration (Klassy) | `klassy/klassyrc` | same file |

**Reversal** icons and the **Klassy** plugin are not included in this repository (third-party).
Install Klassy first (e.g. AUR `klassy-bin`) and Reversal from the KDE Store.

## Structure

```
plasma/desktoptheme/     # Plasma styles
color-schemes/           # KDE color schemes
kvantum/                 # Kvantum themes (Qt apps)
look-and-feel/           # Global themes
klassy/                  # Klassy decoration config
install.sh               # Installs everything for the current user
scripts/switch-theme.sh  # Switch dark ↔ light at runtime
scripts/sync-from-system.sh  # Updates the repo from the system
```

## Switch dark / light

After both themes are installed:

```bash
./scripts/switch-theme.sh          # toggle
./scripts/switch-theme.sh dark     # force dark
./scripts/switch-theme.sh light    # force light
```

Applies the global theme, color scheme, Plasma style, Kvantum, and Reversal icons when available (`Reversal-purple-dark` / `Reversal-purple`).

## Installation (new machine)

```bash
# 1. Install Klassy (AUR)
yay -S klassy-bin   # or whichever method you prefer

# 2. Clone and install Panda
git clone git@github.com:satodu/kde-panda-rounded-theme.git
cd kde-panda-rounded-theme
./install.sh          # dark + light (default Kvantum = Panda dark)
# or: ./install.sh dark
# or: ./install.sh light
```

Then in **System Settings → Appearance**:

1. Global Themes → **Panda Rounded** or **Panda Rounded Light**
2. (Optional) Application Style → **Kvantum** if not already set
3. Window Decorations → **Klassy**
4. Icons → **Reversal-purple** (or another Reversal variant)

## Backup / sync from system to git

If you edit the installed themes:

```bash
./scripts/sync-from-system.sh
git add -A && git status
git commit -m "..."
git push
```

## Credits

- Theme based on **Rounded** (Alexey Varfolomeev)
- Recommended icons: **Reversal** (original author on the KDE Store — not included)
- Decoration: **Klassy** ([paulmcauley/klassy](https://github.com/paulmcauley/klassy) — not included)
