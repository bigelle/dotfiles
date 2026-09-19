-- =============================================================================
-- LSP
--
-- Добавить сервер:
--   1. :Mason → установить бинарник (или поставить системным пакетным менеджером)
--   2. дописать имя в vim.lsp.enable({...}) ниже
--   3. кастомные settings — отдельным файлом ~/.config/nvim/lsp/<name>.lua
--
-- Статус:    :checkhealth vim.lsp   (оно же :LspInfo от lspconfig)
-- Управление: :lsp enable|stop|restart   (встроенная команда 0.12)
-- =============================================================================

vim.lsp.enable({
    "lua_ls",
    -- "gopls",
    -- "rust_analyzer",
    -- "ts_ls",
    -- "pyright",
})

-- =============================================================================
-- Маппинги и возможности при подключении сервера
--
-- Встроено в Neovim (добавлять НЕ надо):
--   K       hover            grn   rename
--   gra     code action      grr   references
--   gri     implementation   grt   type definition
--   gO      document symbols <C-S> signature help (insert)
--   [d ]d   переход по диагностикам
-- =============================================================================

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then return end
        local buf = args.buf

        -- gd: встроенного маппинга нет (дефолтный gd — локальное объявление).
        -- Назад возвращает <C-t> (vim.lsp.buf.definition кладёт позицию в tagstack).
        vim.keymap.set("n", "gd", vim.lsp.buf.definition,
            { buffer = buf, desc = "LSP: определение" })

        -- inlay hints — типы и имена параметров прямо в тексте
        if client:supports_method("textDocument/inlayHint") then
            vim.keymap.set("n", "<leader>lh", function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }),
                    { bufnr = buf })
            end, { buffer = buf, desc = "LSP: inlay hints вкл/выкл" })
        end

        -- подсветка вхождений слова под курсором
        if client:supports_method("textDocument/documentHighlight") then
            local g = vim.api.nvim_create_augroup("lsp_highlight_" .. buf, { clear = true })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                group = g, buffer = buf, callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                group = g, buffer = buf, callback = vim.lsp.buf.clear_references,
            })
        end
    end,
})

-- =============================================================================
-- Форматирование при сохранении
--
-- Одна глобальная автокоманда, а не по одной на каждый attach — иначе при двух
-- серверах на буфер (напр. ts_ls + eslint) формат отрабатывал бы дважды.
-- Выключить:  :Autoformat        (глобально)
--             :Autoformat buffer (только этот буфер)
-- =============================================================================

vim.g.autoformat = true

vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = true }),
    callback = function(args)
        if vim.g.autoformat == false or vim.b[args.buf].autoformat == false then return end
        vim.lsp.buf.format({ bufnr = args.buf, timeout_ms = 2000 })
    end,
})

vim.api.nvim_create_user_command("Autoformat", function(opts)
    if opts.args == "buffer" then
        vim.b.autoformat = not (vim.b.autoformat ~= false)
        vim.notify("autoformat (буфер): " .. tostring(vim.b.autoformat ~= false))
    else
        vim.g.autoformat = not (vim.g.autoformat ~= false)
        vim.notify("autoformat: " .. tostring(vim.g.autoformat ~= false))
    end
end, { nargs = "?", complete = function() return { "buffer" } end, desc = "Формат при сохранении вкл/выкл" })
