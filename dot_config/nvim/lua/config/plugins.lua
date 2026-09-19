-- =============================================================================
-- PLUGINS (vim.pack — встроенный менеджер 0.12)
--
-- Добавить плагин:  строка в vim.pack.add → перезапуск → подтвердить (y) → setup ниже
-- Обновить:         :lua vim.pack.update()   → просмотреть diff → :w
-- Удалить:          убрать строку, затем :lua vim.pack.del({ "имя-репо" })
-- Что стоит:        :lua vim.print(vim.pack.get())
-- =============================================================================

local gh = function(x) return "https://github.com/" .. x end

vim.pack.add({
    -- Каталог готовых LSP-конфигов (cmd / filetypes / root_markers).
    -- В 0.12 это просто набор файлов lsp/*.lua — сам клиент встроен в Neovim.
    gh("neovim/nvim-lspconfig"),

    -- Установка LSP-серверов, форматтеров и линтеров: :Mason
    gh("mason-org/mason.nvim"),

    -- Парсеры и queries для treesitter (ветка main — обязательно)
    { src = gh("nvim-treesitter/nvim-treesitter"), version = "main" },

    -- Fuzzy finder
    gh("nvim-mini/mini.pick"),
    gh("nvim-mini/mini.extra"),  -- пикеры для lsp, diagnostics, oldfiles, keymaps
    gh("nvim-lua/plenary.nvim"), -- зависимость todo-comments

    -- Быстрые «закладки» на файлы
    { src = gh("ThePrimeagen/harpoon"),            version = "harpoon2" },

    gh("folke/todo-comments.nvim"),       -- подсветка TODO/FIXME/HACK
    gh("folke/which-key.nvim"),           -- подсказка маппингов
    gh("nvim-mini/mini.icons"),           -- иконки
    gh("nvim-mini/mini.surround"),        -- sa/sd/sr — кавычки, скобки, теги
    gh("nvim-mini/mini.diff"),            -- git-знаки в signcolumn + hunk-операции
    gh("vague-theme/vague.nvim"),         -- colorscheme
    gh("christoomey/vim-tmux-navigator"), -- <C-hjkl> между окнами nvim и панелями tmux
})

-- Встроенные opt-плагины 0.12 (не грузятся сами)
vim.cmd("packadd nvim.undotree") -- :Undotree
-- vim.cmd("packadd nvim.difftool") -- :DiffTool dir1 dir2
-- vim.cmd("packadd nvim.tohtml")   -- :TOhtml

-- =============================================================================
-- SETUP
-- =============================================================================

-- colorscheme первым, чтобы остальное рендерилось поверх
require("vague").setup({ transparent = true })
vim.cmd.colorscheme("vague")

-- mason: только установщик бинарников. Включение серверов — в config/lsp.lua
require("mason").setup()

-- treesitter: setup() ничего не включает, он только задаёт install_dir.
-- Установить парсер:   :TSInstall go rust
-- Обновить все:        :TSUpdate
-- Подсветка включается в config/autocmds.lua (FileType → vim.treesitter.start)
require("nvim-treesitter").setup()

require("mini.pick").setup()
require("mini.extra").setup()
vim.ui.select = MiniPick.ui_select -- :Conf и code actions теперь в том же окне

require("which-key").setup()

require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons() -- без этого telescope не видит иконки

require("mini.surround").setup()
require("mini.diff").setup()

require("todo-comments").setup()

require("harpoon"):setup()
