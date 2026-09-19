-- =============================================================================
-- OPTIONS
-- =============================================================================

local o           = vim.o

-- ── UI ───────────────────────────────────────────────────────────────────────
o.number          = true
o.relativenumber  = true
o.signcolumn      = "yes" -- всегда колонка знаков (без прыжков текста)
o.cursorline      = true
o.termguicolors   = true
o.laststatus      = 3         -- одна статусная строка на все окна
o.winborder       = "rounded" -- рамки ВСЕХ float-окон (hover, diagnostics, ui.select)
o.wrap            = false
o.scrolloff       = 8
o.sidescrolloff   = 8
o.smoothscroll    = true -- плавный скролл длинных wrapped-строк
o.splitright      = true
o.splitbelow      = true
o.splitkeep       = "screen" -- текст не прыгает при открытии сплита
o.mouse           = "a"
o.confirm         = true     -- вместо E37 спрашивает «сохранить?»
o.inccommand      = "split"  -- живой предпросмотр :s///
o.list            = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- ── Отступы ──────────────────────────────────────────────────────────────────
o.tabstop         = 4
o.shiftwidth      = 4
o.expandtab       = true
o.smartindent     = true
o.breakindent     = true

-- ── Поиск ────────────────────────────────────────────────────────────────────
o.ignorecase      = true
o.smartcase       = true

if vim.fn.executable("rg") == 1 then
    o.grepprg    = "rg --vimgrep --smart-case"
    o.grepformat = "%f:%l:%c:%m"
end

-- ── Складки (treesitter, встроенный foldexpr) ────────────────────────────────
-- Если парсера нет — просто не будет складок, ошибки не будет.
o.foldmethod        = "expr"
o.foldexpr          = "v:lua.vim.treesitter.foldexpr()"
o.foldtext          = "" -- 0.10+: показывать реальный текст строки с подсветкой
o.foldlevel         = 99 -- всё развёрнуто по умолчанию
o.foldlevelstart    = 99

-- ── Файлы ────────────────────────────────────────────────────────────────────
o.undofile          = true -- undodir по умолчанию уже stdpath('state')/undo — не трогаем
o.swapfile          = false
-- o.exrc   = true -- проектные .nvim.lua (спрашивает доверие при первом запуске)

-- ── Автодополнение: 100% нативное (0.12), без плагинов ────────────────────────
-- 'autocomplete' сам показывает меню по мере набора, источники берутся из 'complete'.
o.autocomplete      = true
o.autocompletedelay = 100
require("config.pathcomplete")
o.completefunc = "v:lua.PathComplete"
o.complete     = "o^10,F^5"                          -- LSP (до 10) + пути (до 5). Слова из буферов: добавь ",.,w"
o.completeopt  = "menu,menuone,noselect,fuzzy,popup" -- popup = окно с докой
o.pumheight    = 10
o.pummaxwidth  = 60
o.pumborder    = "rounded"
vim.opt.shortmess:append("c") -- без «match 1 of 3» в cmdline

-- ── Тайминги ─────────────────────────────────────────────────────────────────
o.updatetime = 250
o.timeoutlen = 300

-- ── Прочее ───────────────────────────────────────────────────────────────────
o.jumpoptions = "stack,view,clean"     -- прыжки как в браузере + восстановление вида
vim.opt.diffopt:append("linematch:60") -- умный diff по словам внутри строк

-- ── Экспериментальный UI 0.12 (замена noice.nvim) ────────────────────────────
-- Подсветка cmdline, пейджер как обычный буфер, никаких «Press ENTER».
-- Если сломается — просто закомментируй строку.
pcall(function() require("vim._extui").enable({}) end)
