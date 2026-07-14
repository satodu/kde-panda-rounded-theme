# Panda Rounded Theme

Pacote completo (escuro + claro) para KDE Plasma 6:

| Componente | Escuro | Claro |
|------------|--------|-------|
| Plasma Style | `Panda-theme` | `Panda-theme-light` |
| Cores | `Panda Color` | `Panda Light` |
| Kvantum | `Panda` | `PandaLight` |
| Global Theme | `Panda Rounded` | `Panda Rounded Light` |
| Decoração (Klassy) | `klassy/klassyrc` | mesmo ficheiro |

Ícones **Reversal** e o plugin **Klassy** não entram neste repositório (são de terceiros).
Instale Klassy primeiro (ex.: AUR `klassy-bin`) e Reversal na KDE Store.

## Estrutura

```
plasma/desktoptheme/     # Estilos Plasma
color-schemes/           # Esquemas de cores KDE
kvantum/                 # Temas Kvantum (apps Qt)
look-and-feel/           # Temas globais
klassy/                  # Config da decoração Klassy
install.sh               # Instala tudo no usuário
scripts/sync-from-system.sh  # Atualiza o repo a partir do sistema
```

## Instalação (nova máquina)

```bash
# 1. Instalar Klassy (AUR)
yay -S klassy-bin   # ou o método que preferires

# 2. Clonar e instalar o Panda
git clone git@github.com:satodu/kde-panda-rounded-theme.git
cd kde-panda-rounded-theme
./install.sh          # dark + light (Kvantum padrão = Panda escuro)
# ou: ./install.sh dark
# ou: ./install.sh light
```

Depois em **Configurações do Sistema → Aparência**:

1. Temas Globais → **Panda Rounded** ou **Panda Rounded Light**
2. (Opcional) Estilo de aplicativo → **Kvantum** se ainda não estiver
3. Decoração de janelas → **Klassy**
4. Ícones → **Reversal-purple** (ou outra variante Reversal)

## Backup / sincronizar do sistema para o git

Se você editar os temas instalados:

```bash
./scripts/sync-from-system.sh
git add -A && git status
git commit -m "..."
git push
```

## Créditos

- Tema baseado em **Rounded** (Alexey Varfolomeev)
- Ícones recomendados: **Reversal** (autor original na KDE Store — não incluso)
- Decoração: **Klassy** ([paulmcauley/klassy](https://github.com/paulmcauley/klassy) — não incluso)
