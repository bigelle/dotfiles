-- =============================================================================
-- NEOVIM 0.12 CONFIG
--
-- ~/.config/nvim/
-- ├── init.lua              ← ты здесь: только порядок загрузки
-- ├── lua/config/
-- │   ├── options.lua       опции редактора
-- │   ├── plugins.lua       vim.pack.add + setup плагинов
-- │   ├── lsp.lua           серверы, LspAttach, format-on-save
-- │   ├── diagnostics.lua   вид диагностики
-- │   ├── keymaps.lua       глобальные маппинги
-- │   ├── autocmds.lua      автокоманды (yank, treesitter, cursor)
-- │   └── confnav.lua       :Conf / :ConfBack — навигация по конфигу
-- └── lsp/
--     └── lua_ls.lua        настройки конкретных LSP-серверов
--
-- Правки: :Conf  → выбрать файл → поправить → :ConfBack (перезапуск + возврат)
-- =============================================================================

-- leader должен быть установлен ДО загрузки плагинов и маппингов
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.plugins")
require("config.lsp")
require("config.diagnostics")
require("config.keymaps")
require("config.autocmds")
require("config.confnav")
