# Dotfiles
This is are my personal dotfiles managed by [chezmoi](https://www.chezmoi.io/).
It manages my:
- git config
- KDE
- vicinae (dock)
- packages (Arch and AUR)
- kitty terminal
- pywal16 colorschemes
And many more

# Installation

## 0. Install chezmoi
On Arch:
```sh
sudo pacman -S chezmoi
```

## 1. Install dotfiles
```sh
chezmoi init --apply bigelle
```

## 2. Reboot (recommended)
```sh
sudo reboot
```

# Disclaimer
Everything is untested. It works on my machine, but I've never tried to use this dotfiles on any other machine.
