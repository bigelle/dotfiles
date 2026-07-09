#!/usr/bin/env bash
# ~/.local/bin/tmux-sessionizer.sh
#
# Быстрый переключатель tmux-сессий по проектам.
# Показывает папки первого уровня внутри ~/Projects через fzf,
# создаёт (или переключает на существующую) сессию с именем = имя папки.
#
# Требуется: fzf (sudo apt install fzf / brew install fzf)

set -euo pipefail

# --- Здесь список корневых папок с проектами ---
# Можно добавить ещё пути через пробел, например:
# SEARCH_PATHS=(~/Projects ~/work)
SEARCH_PATHS=(~/Projects)

# собираем список папок первого уровня из всех SEARCH_PATHS
selected=$(find "${SEARCH_PATHS[@]}" -mindepth 1 -maxdepth 1 -type d 2>/dev/null \
    | fzf --prompt="Выбери проект > " --height=100% --reverse)

# если ничего не выбрали (Esc) — просто выходим
if [[ -z "${selected}" ]]; then
    exit 0
fi

# имя сессии = имя папки, "." и ":" заменяем на "_" (tmux не любит их в именах)
session_name=$(basename "$selected" | tr '.:' '_')

# если сессии с таким именем ещё нет — создаём (detached)
if ! tmux has-session -t "$session_name" 2>/dev/null; then
    tmux new-session -ds "$session_name" -c "$selected"
fi

# переключаемся на неё:
# - если мы уже внутри tmux (запущено из popup) — switch-client
# - если снаружи — attach-session
if [[ -n "${TMUX:-}" ]]; then
    tmux switch-client -t "$session_name"
else
    tmux attach-session -t "$session_name"
fi
