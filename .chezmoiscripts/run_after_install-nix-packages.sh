#!/usr/bin/env bash
set -euo pipefail

# Явно подгружаем nix в PATH, т.к. run_after-скрипты chezmoi
# не наследуют интерактивное shell-окружение (.zshrc/.bashrc не сорсятся)
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

FLAKE_DIR="$HOME/.config/nix-pkgs"
PROFILE_NAME="nix-pkgs"

if [ ! -d "$FLAKE_DIR" ]; then
  echo "Предупреждение: Директория $FLAKE_DIR с flake.nix не найдена."
  exit 0
fi

echo "==> Синхронизация пакетов из $FLAKE_DIR..."

if nix profile list --extra-experimental-features "nix-command flakes" 2>/dev/null | grep -q "^Name:[[:space:]]*${PROFILE_NAME}$"; then
  nix profile upgrade "$PROFILE_NAME" --extra-experimental-features "nix-command flakes" --refresh
else
  nix profile install "$FLAKE_DIR" --extra-experimental-features "nix-command flakes"
fi
