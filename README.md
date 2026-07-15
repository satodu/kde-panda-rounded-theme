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

After both themes are installed, you can easily toggle or switch themes at runtime:

```bash
./scripts/switch-theme.sh          # toggle dark ↔ light
./scripts/switch-theme.sh dark     # force dark theme
./scripts/switch-theme.sh light    # force light theme
```

This command automatically applies the global theme, color scheme, Plasma style, Kvantum, and Reversal icons when available (`Reversal-purple-dark` / `Reversal-purple`).

## Installation (new machine) / Applying Updates

If you are setting up a new machine, or if you pulled new updates from Git:

```bash
# 1. Install Klassy (AUR)
yay -S klassy-bin   # or whichever method you prefer

# 2. Clone/pull the repo and install Panda Rounded
./install.sh          # Installs dark + light (and copies Panel Colorizer presets if present)
# or: ./install.sh dark
# or: ./install.sh light
```

Then, in **System Settings → Appearance**:
1. Global Themes → **Panda Rounded** or **Panda Rounded Light**
2. (Optional) Application Style → **Kvantum** if not already set
3. Window Decorations → **Klassy**
4. Icons → **Reversal-purple** (or another Reversal variant)

## Backup / sync from system to git

If you customize the themes, edit colors, Kvantum configurations, Klassy settings, or **Panel Colorizer** settings:

1. **For Panel Colorizer**: Open the Panel Colorizer settings GUI in Plasma, go to the Preset Manager, and **Export** your current configuration. This saves it to `~/.config/panel-colorizer/presets/`.
2. Run the sync script to pull all files from your system to this repository:
   ```bash
   ./scripts/sync-from-system.sh
   ```
3. Commit and push the changes:
   ```bash
   git add -A
   git status
   git commit -m "style: update theme configuration"
   git push
   ```
## Credits

- Theme based on **Rounded** (Alexey Varfolomeev)
- Recommended icons: **Reversal** (original author on the KDE Store — not included)
- Decoration: **Klassy** ([paulmcauley/klassy](https://github.com/paulmcauley/klassy) — not included)
