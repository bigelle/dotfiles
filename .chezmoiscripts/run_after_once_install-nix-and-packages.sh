#!/usr/bin/env bash
set -euo pipefail

# 1. Установка Nix Package Manager (если еще не установлен)
if ! command -v nix >/dev/null 2>&1; then
  echo "==> Установка Nix Package Manager..."
  # Официальный мультипользовательский установщик Determinate Systems (рекомендуется для Flakes out-of-the-box)
  curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh -s -- --daemon
  
  # Подгружаем Nix в текущую сессию
  if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
    . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
  fi
fi

# 2. Включение поддержки Flakes (на случай если используется классический инсталлер)
mkdir -p ~/.config/nix
if ! grep -q "experimental-features" ~/.config/nix/nix.conf 2>/dev/null; then
  echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
fi

# 3. Установка/Обновление пакетов из flake.nix
FLAKE_DIR="$HOME/.config/nix-pkgs"

if [ -d "$FLAKE_DIR" ]; then
  echo "==> Установка пакетов из $FLAKE_DIR..."
  nix profile install "$FLAKE_DIR" --extra-experimental-features "nix-command flakes"
else
  echo "Предупреждение: Директория $FLAKE_DIR с flake.nix не найдена."
fi
