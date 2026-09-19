-- =============================================================================
-- KEYMAPS
--
-- Встроено в Neovim, дублировать не надо:
--   K hover · grn rename · gra code action · grr references · gri implementation
--   grt type definition · gO symbols · <C-S> signature (insert) · [d ]d диагностики
--   <C-hjkl> между окнами — даёт vim-tmux-navigator (работает и без tmux)
-- =============================================================================

local map = vim.keymap.set

-- ── ФАЙЛЫ ────────────────────────────────────────────────────────────────────
map("n", "<leader>ff", "<cmd>Pick files<cr>", { desc = "Найти файл" })
map("n", "<leader>fg", "<cmd>Pick grep_live<cr>", { desc = "Grep по проекту" })
map("n", "<leader>fb", "<cmd>Pick buffers<cr>", { desc = "Буферы" })
map("n", "<leader>fr", "<cmd>Pick oldfiles<cr>", { desc = "Недавние файлы" })
map("n", "<leader>fh", "<cmd>Pick help<cr>", { desc = "Справка" })
map("n", "<leader>fk", "<cmd>Pick keymaps<cr>", { desc = "Маппинги" })
map("n", "<leader>fR", "<cmd>Pick resume<cr>", { desc = "Вернуть прошлый поиск" })

-- ── LSP ──────────────────────────────────────────────────────────────────────
map("n", "<leader>ls", "<cmd>Pick lsp scope='document_symbol'<cr>", { desc = "Символы файла" })
map("n", "<leader>lw", "<cmd>Pick lsp scope='workspace_symbol'<cr>", { desc = "Символы проекта" })
map("n", "<leader>lf", function() vim.lsp.buf.format() end, { desc = "Форматировать" })
map("n", "<leader>li", "<cmd>checkhealth vim.lsp<cr>", { desc = "Статус LSP" })
map("n", "<leader>lr", "<cmd>lsp restart<cr>", { desc = "Перезапустить LSP" })

-- ── ДИАГНОСТИКА ──────────────────────────────────────────────────────────────
map("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Диагностика: показать" })
map("n", "<leader>dl", "<cmd>Pick diagnostic<cr>", { desc = "Диагностика: список" })
map("n", "<leader>dq", vim.diagnostic.setloclist, { desc = "Диагностика: в loclist" })
map("n", "<leader>dv", function()
    local cur = vim.diagnostic.config().virtual_lines
    vim.diagnostic.config({
        virtual_lines = cur and false or { current_line = true },
    })
end, { desc = "Диагностика: развернуть все на строке" })

-- ── КОНФИГ ───────────────────────────────────────────────────────────────────
map("n", "<leader>ce", "<cmd>Conf<cr>", { desc = "Открыть конфиг" })
map("n", "<leader>cb", "<cmd>ConfBack<cr>", { desc = "Назад + рестарт" })
map("n", "<leader>cB", "<cmd>ConfBack!<cr>", { desc = "Назад без рестарта" })
map("n", "<leader>cr", "<cmd>ConfRestart<cr>", { desc = "Перезапустить nvim" })
map("n", "<leader>cp", function() vim.pack.update() end, { desc = "Обновить плагины" })

-- ── HARPOON ──────────────────────────────────────────────────────────────────
local harpoon = require("harpoon")
map("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Harpoon: добавить" })
map("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon: меню" })
for i = 1, 4 do
    map("n", "<leader>" .. i, function() harpoon:list():select(i) end, { desc = "Harpoon " .. i })
end

-- ── АВТОДОПОЛНЕНИЕ ───────────────────────────────────────────────────────────
-- Меню открывает сама опция 'autocomplete'; здесь только навигация по нему.
map("i", "<Tab>", function() return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>" end,
    { expr = true, desc = "Следующий вариант" })
map("i", "<S-Tab>", function() return vim.fn.pumvisible() == 1 and "<C-p>" or "<S-Tab>" end,
    { expr = true, desc = "Предыдущий вариант" })
map("i", "<CR>", function()
    if vim.fn.pumvisible() == 0 then return "<CR>" end
    return vim.fn.complete_info({ "selected" }).selected ~= -1 and "<C-y>" or "<C-e><CR>"
end, { expr = true, desc = "Подтвердить вариант" })

-- ── ПРОЧЕЕ ───────────────────────────────────────────────────────────────────
map("n", "<leader>u", "<cmd>Undotree<cr>", { desc = "Дерево undo" })
map("n", "<leader>td", "<cmd>TodoQuickFix<cr>", { desc = "TODO по проекту" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Снять подсветку поиска" })

-- перемещение выделенных строк
map("v", "J", ":m '>+1<cr>gv=gv", { desc = "Сдвинуть строки вниз" })
map("v", "K", ":m '<-2<cr>gv=gv", { desc = "Сдвинуть строки вверх" })

-- вставка поверх выделения не затирает регистр
map("x", "<leader>p", [["_dP]], { desc = "Вставить, сохранив регистр" })

-- явная работа с системным буфером
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Копировать в систему" })
map({ "n", "v" }, "<leader>P", [["+p]], { desc = "Вставить из системы" })
