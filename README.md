# Panda Rounded Theme

Pacote completo (escuro + claro) para KDE Plasma 6:

| Componente | Escuro | Claro |
|------------|--------|-------|
| Plasma Style | `Panda-theme` | `Panda-theme-light` |
| Cores | `Panda Color` | `Panda Light` |
| Kvantum | `Panda` | `PandaLight` |
| Global Theme | `Panda Rounded` | `Panda Rounded Light` |

Ícones **Reversal** não entram neste repositório (são de terceiros). Instale à parte na KDE Store / Store.

## Estrutura

```
plasma/desktoptheme/     # Estilos Plasma
color-schemes/           # Esquemas de cores KDE
kvantum/                 # Temas Kvantum (apps Qt)
look-and-feel/           # Temas globais
install.sh               # Instala tudo no usuário
scripts/sync-from-system.sh  # Atualiza o repo a partir do sistema
```

## Instalação (nova máquina)

```bash
git clone git@github.com:satodu/kde-panda-rounded-theme.git
cd kde-panda-rounded-theme
./install.sh          # dark + light (Kvantum padrão = Panda escuro)
# ou: ./install.sh dark
# ou: ./install.sh light
```

Depois em **Configurações do Sistema → Aparência**:

1. Temas Globais → **Panda Rounded** ou **Panda Rounded Light**
2. (Opcional) Estilo de aplicativo → **Kvantum** se ainda não estiver
3. Ícones → **Reversal-purple** (ou outra variante Reversal)

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
