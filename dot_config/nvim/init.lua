-- =============================================================================
-- NEOVIM 0.12 CONFIG
-- Структура: OPTIONS → PLUGINS → LSP → COMPLETION → KEYMAPS → UI
--
-- Добавить новый LSP-сервер:
--   1. Установить через :Mason
--   2. Добавить имя в vim.lsp.enable({...}) ниже
--   3. Опционально: создать ~/.config/nvim/lsp/servername.lua для кастомных settings
--
-- Добавить плагин:
--   1. Добавить строку в vim.pack.add({...}) ниже
--   2. Написать setup() после блока vim.pack.add
-- =============================================================================

-- =============================================================================
-- OPTIONS
-- =============================================================================

vim.g.mapleader      = " "
vim.g.maplocalleader = " "

local opt            = vim.opt

opt.number           = true  -- номера строк
opt.relativenumber   = true  -- относительные номера
opt.signcolumn       = "yes" -- всегда показывать колонку знаков (без прыжков)
opt.cursorline       = true  -- подсветка текущей строки

opt.tabstop          = 4     -- ширина таба
opt.shiftwidth       = 4     -- отступ при >> и <<
opt.expandtab        = true  -- таб → пробелы
opt.smartindent      = true

opt.ignorecase       = true  -- регистронезависимый поиск...
opt.smartcase        = true  -- ...если нет заглавных

opt.wrap             = false -- не переносить длинные строки
opt.scrolloff        = 8     -- запас строк при скролле
opt.sidescrolloff    = 8

opt.splitright       = true -- вертикальный сплит вправо
opt.splitbelow       = true -- горизонтальный сплит вниз

opt.laststatus       = 3

opt.undofile         = true      -- персистентный undo между сессиями
opt.undodir          = vim.fn.stdpath("data") .. "/undodir"
opt.swapfile         = false     -- без swap-файлов

opt.termguicolors    = true      -- 24-bit цвета
opt.winborder        = "rounded" -- скруглённые рамки у float-окон (LSP hover и т.д.)

opt.completeopt      = "fuzzy,menu,menuone,noselect"
opt.shortmess:append("c") -- меньше мусора от completion-меню
opt.complete   = "o"      -- только LSP, без буфера/путей/тегов
opt.pumheight  = 5
opt.pumborder  = "rounded"

opt.updatetime = 250 -- быстрее CursorHold (нужно для LSP highlights)
opt.timeoutlen = 300 -- быстрее which-key

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking text",
    callback = function()
        vim.hl.on_yank()
    end,
})
-- =============================================================================
-- PLUGINS (vim.pack — встроенный менеджер 0.12)
-- После добавления нового плагина — перезапусти nvim, подтверди установку (y)
-- Обновить плагины: vim.pack.update({}) → :w для подтверждения
-- =============================================================================

local gh = function(x) return "https://github.com/" .. x end

vim.pack.add({
    -- каталог LSP-конфигов (cmd, filetypes, root_markers) под сотни серверов
    gh("neovim/nvim-lspconfig"),

    -- установка LSP-серверов через :Mason
    gh("williamboman/mason.nvim"),

    -- мост: Mason ↔ vim.lsp.enable (автоматически включает серверы после установки)
    gh("williamboman/mason-lspconfig.nvim"),

    -- подсветка синтаксиса через treesitter (нужен для языков вне встроенных парсеров)
    { src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },

    -- fuzzy finder: файлы, grep, буферы, LSP-символы
    gh("nvim-telescope/telescope.nvim"),
    gh("nvim-lua/plenary.nvim"), -- зависимость telescope

    -- навигация по файлам — v2 API (ветка harpoon2)
    { src = gh("ThePrimeagen/harpoon"),            version = "harpoon2" },

    -- подсветка TODO/FIXME/NOTE/HACK в комментариях
    gh("folke/todo-comments.nvim"),

    -- показывает доступные keymaps при паузе
    gh("folke/which-key.nvim"),

    -- иконки (используются telescope и другими)
    gh("echasnovski/mini.icons"),

    -- colorscheme (замени на любой другой по вкусу)
    gh("vague-theme/vague.nvim"),

    gh("christoomey/vim-tmux-navigator"),

    gh("nvim-mini/mini.surround"),

    gh("nvim-mini/mini.diff"),

    gh("nvim-mini/mini.completion"),
})


-- встроенные opt-плагины 0.12 (не грузятся автоматически)
vim.cmd("packadd nvim.undotree") -- :Undotree
-- vim.cmd("packadd nvim.difftool")   -- :DiffTool (раскомментировать если нужен)
-- vim.cmd("packadd nvim.tohtml")     -- :TOhtml   (раскомментировать если нужен)


-- =============================================================================
-- PLUGIN SETUP
-- =============================================================================

-- colorscheme — первым, чтобы остальное рендерилось поверх
require("vague").setup({
    transparent = true,
})
vim.cmd.colorscheme('vague')

vim.lsp.config('*', {
    capabilities = require('mini.completion').get_lsp_capabilities(),
})

-- mason — менеджер LSP-серверов
-- Открыть UI: :Mason
-- Установить сервер: :MasonInstall <name>
require("mason").setup()

-- mason-lspconfig — после mason.setup()
-- auto_enable: автоматически вызывает vim.lsp.enable для установленных серверов
require("mason-lspconfig").setup({
    automatic_enable = true,
})

-- treesitter — только установка парсеров, highlighting работает сам
-- Установить парсер для языка: :TSInstall <lang>
-- Обновить все парсеры: :TSUpdate
require("nvim-treesitter").setup()

-- telescope
require("telescope").setup({
    defaults = {
        layout_strategy = "horizontal",
        sorting_strategy = "ascending",
        layout_config = { prompt_position = "top" },
    },
})

-- which-key
require("which-key").setup()

-- mini.icons
require("mini.icons").setup()

require("mini.surround").setup()

require('mini.diff').setup()

require('mini.completion').setup({
    delay = { completion = 100, info = 100, signature = 50 },
    window = {
        info      = { height = 20, width = 80, border = 'rounded' },
        signature = { height = 20, width = 80, border = 'rounded' },
    },
    lsp_completion = {
        source_func = 'omnifunc',
        auto_setup = false,
    },
    fallback_action = '<C-n>',
})
-- =============================================================================
-- LSP
--
-- Серверы включаются двумя путями:
--   A) mason-lspconfig с automatic_enable = true — автоматически для установленных
--   B) vim.lsp.enable({...}) — явно, для серверов установленных вручную вне Mason
--
-- Настройки под конкретный сервер:
-- Пример: ~/.config/nvim/lsp/lua_ls.lua
-- vim.lsp.config("lua_ls", {
--     settings = {
--         Lua = { diagnostics = { globals = { "vim" } } }
--     }
-- })
--
-- Проверить статус LSP: :checkhealth vim.lsp
-- =============================================================================
vim.lsp.config("lua_ls", {
    settings = {
        Lua = { diagnostics = { globals = { "vim" } } }
    }
})

-- Пример: если сервер установлен не через Mason, а через пакетный менеджер ОС
-- vim.lsp.enable({ "gopls", "rust_analyzer" })

-- LSP completion — включается при attach к буферу
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then return end

        -- встроенный автокомплит от LSP (заменяет nvim-cmp)
        if client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
        end

        -- LSP hover поверх man.lua (иначе K открывает сплит с man-страницей)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = args.buf, desc = "LSP hover" })
        vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { buffer = args.buf, desc = "LSP format" })
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = args.buf,
            callback = function() vim.lsp.buf.format({ async = false }) end,
        })

        -- Map 'gd' to jump to definition
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = args.buf, desc = 'Go to definition' })

        -- Optional: Map '<C-t>' to jump back to where you were
        vim.keymap.set('n', '<C-t>', '<C-t>', { buffer = args.buf, desc = 'Jump back' })

        -- inlay hints (типы, имена параметров) — включить если нужно
        -- if client:supports_method("textDocument/inlayHint") then
        --   vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
        -- end
    end,
})

-- встроенный автокомплит (работает независимо от LSP — буфер, пути и т.д.)
vim.o.autocomplete = true


-- =============================================================================
-- DIAGNOSTICS
-- =============================================================================

local sev = vim.diagnostic.severity

vim.diagnostic.config({
    severity_sort    = true,
    update_in_insert = false,
    virtual_lines    = false,
    virtual_text     = {
        prefix = "●",
        spacing = 4,
    },
    signs            = {
        text = {
            [sev.ERROR] = "E",
            [sev.WARN]  = "W",
            [sev.INFO]  = "I",
            [sev.HINT]  = "H",
        },
    },
    float            = {
        border = "rounded",
        source = true, -- показывать имя LSP-сервера в float
    },
})


-- =============================================================================
-- KEYMAPS
--
-- Встроенные LSP-маппинги (не нужно добавлять вручную):
--   K       — hover документация
--   grn     — rename
--   gra     — code action
--   grr     — references
--   gri     — implementation
--   grt     — type definition
--   gO      — document symbols
--   <C-S>   — signature help (insert mode)
--   [d / ]d — предыдущая/следующая диагностика (0.11+)
-- =============================================================================

local map = vim.keymap.set

-- ФАЙЛЫ
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find file" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffer" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })

-- LSP (дополнение к встроенным)
map("n", "<leader>ld", "<cmd>Telescope lsp_definitions<cr>", { desc = "LSP definition" })
map("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "LSP symbols" })
map("n", "<leader>lw", "<cmd>Telescope lsp_workspace_symbols<cr>", { desc = "LSP workspace symbols" })
map("n", "<leader>li", "<cmd>LspInfo<cr>", { desc = "LSP info" })
map("n", "<leader>lr", "<cmd>lsp restart<cr>", { desc = "LSP restart" })

-- ДИАГНОСТИКА
map("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Diagnostic float" })
map("n", "<leader>dl", "<cmd>Telescope diagnostics<cr>", { desc = "Diagnostic list" })

-- HARPOON
local harpoon = require("harpoon")
harpoon:setup()
map("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Harpoon add" })
map("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon menu" })
map("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon 1" })
map("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon 2" })
map("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon 3" })
map("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon 4" })

-- COMPLETION (Tab/S-Tab для навигации по вариантам)
map("i", "<Tab>", function()
    return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>"
end, { expr = true, desc = "Next completion / Tab" })

map("i", "<S-Tab>", function()
    return vim.fn.pumvisible() == 1 and "<C-p>" or "<S-Tab>"
end, { expr = true, desc = "Prev completion / S-Tab" })

-- Enter подтверждает выбранный вариант без вставки новой строки
map("i", "<CR>", function()
    if vim.fn.pumvisible() == 1 then
        local info = vim.fn.complete_info({ "selected" })
        if info.selected ~= -1 then
            return "<C-y>"     -- реально выбран пункт — подтверждаем
        else
            return "<C-e><CR>" -- ничего не выбрано — закрываем меню и сразу переносим строку
        end
    else
        return "<CR>"
    end
end, { expr = true, desc = "Confirm completion / Enter" })

-- MISC
map("n", "<leader>u", "<cmd>Undotree<cr>", { desc = "Undo tree" })
map("n", "<leader>td", "<cmd>TodoTelescope<cr>", { desc = "TODOs" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search" })

-- навигация между сплитами через Ctrl+hjkl
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
