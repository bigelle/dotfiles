# Rose Pine ZSH Theme - Fixed Version
# Inspired by starship/spaceship with Rose Pine color scheme
# Place this file in ~/.oh-my-zsh/themes/rosepine.zsh-theme

# Rose Pine Color Palette
local rose_pine_base='#191724'
local rose_pine_surface='#1f1d2e'
local rose_pine_overlay='#26233a'
local rose_pine_muted='#6e6a86'
local rose_pine_subtle='#908caa'
local rose_pine_text='#e0def4'
local rose_pine_love='#eb6f92'
local rose_pine_gold='#f6c177'
local rose_pine_rose='#ebbcba'
local rose_pine_pine='#31748f'
local rose_pine_foam='#9ccfd8'
local rose_pine_iris='#c4a7e7'
local rose_pine_highlight_low='#21202e'
local rose_pine_highlight_med='#403d52'
local rose_pine_highlight_high='#524f67'

# Color shortcuts using Rose Pine palette
local c_reset="%{$reset_color%}"
local c_user="%{$fg_bold[magenta]%}"      # iris
local c_host="%{$fg_bold[cyan]%}"         # foam
local c_path="%{$fg_bold[yellow]%}"       # gold
local c_git_clean="%{$fg_bold[green]%}"   # pine (closest to green)
local c_git_dirty="%{$fg_bold[red]%}"     # love
local c_git_branch="%{$fg_bold[blue]%}"   # pine
local c_time="%{$fg[white]%}"             # subtle
local c_prompt="%{$fg_bold[magenta]%}"    # iris

# User info
local user_info=""
if [[ $USER != $DEFAULT_USER ]] || [[ -n $SSH_CONNECTION ]]; then
    user_info="${c_user}%n${c_reset}"
    if [[ -n $SSH_CONNECTION ]]; then
        user_info="${user_info}${c_reset}@${c_host}%m${c_reset}"
    fi
    user_info="${user_info} "
fi

# Directory info
local dir_info="${c_path}%~${c_reset}"

# Git info - используем стандартные настройки Oh My Zsh
ZSH_THEME_GIT_PROMPT_PREFIX="${c_git_branch} "
ZSH_THEME_GIT_PROMPT_SUFFIX="${c_reset}"
ZSH_THEME_GIT_PROMPT_DIRTY="${c_git_dirty} ●${c_reset}"
ZSH_THEME_GIT_PROMPT_CLEAN="${c_git_clean} ✓${c_reset}"

# Кастомная функция для git статуса (переименована, чтобы избежать конфликтов)
function rosepine_git_status() {
    # Проверяем, находимся ли мы в git репозитории
    if ! git rev-parse --git-dir &>/dev/null; then
        return
    fi
    
    local branch
    local git_status=""
    
    # Получаем название ветки
    branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    
    if [[ -z "$branch" ]]; then
        return
    fi
    
    # Проверяем статус рабочей директории
    if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
        git_status="${c_git_dirty} ●${c_reset}"
    else
        git_status="${c_git_clean} ✓${c_reset}"
    fi
    
    # Проверяем ahead/behind более надежным способом
    local ahead_behind
    ahead_behind=$(git status --porcelain=v1 --branch 2>/dev/null | head -1)
    
    if [[ "$ahead_behind" == *"ahead"* ]] && [[ "$ahead_behind" == *"behind"* ]]; then
        git_status="${git_status}${c_git_dirty} ↕${c_reset}"
    elif [[ "$ahead_behind" == *"ahead"* ]]; then
        git_status="${git_status}${c_git_dirty} ↑${c_reset}"
    elif [[ "$ahead_behind" == *"behind"* ]]; then
        git_status="${git_status}${c_git_dirty} ↓${c_reset}"
    fi
    
    echo "${c_git_branch} ${branch}${c_reset}${git_status}"
}

# Time info
local time_info="${c_time}%D{%H:%M:%S}${c_reset}"

# Exit code
local exit_code="%(?..%{$fg_bold[red]%} ✗ %?${c_reset})"

# Вариант 1: Использование стандартной функции git_prompt_info (рекомендуется)
PROMPT='${user_info}${dir_info}$(git_prompt_info)${exit_code} ${time_info}
${c_prompt}❯${c_reset} '

# Вариант 2: Использование кастомной функции (раскомментируйте, если нужны дополнительные функции)
# PROMPT='${user_info}${dir_info}$(rosepine_git_status)${exit_code} ${time_info}
# ${c_prompt}❯${c_reset} '

# Right prompt (optional)
RPROMPT=''

# Continuation prompt
PROMPT2="${c_prompt}❯${c_reset} "

# Отключаем автоматическое обновление заголовка терминала (может вызывать дублирование)
DISABLE_AUTO_TITLE="true"
