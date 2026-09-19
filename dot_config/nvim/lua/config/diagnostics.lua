-- =============================================================================
-- DIAGNOSTICS
-- =============================================================================

local sev = vim.diagnostic.severity

vim.diagnostic.config({
    severity_sort    = true,
    update_in_insert = false,

    -- virtual_lines только для строки под курсором: полный текст ошибки виден,
    -- но лапша из многострочных сообщений не разъезжается по всему файлу.
    virtual_lines    = false,
    virtual_text     = { prefix = "●", spacing = 4 },

    signs            = {
        text = {
            [sev.ERROR] = "E",
            [sev.WARN]  = "W",
            [sev.INFO]  = "I",
            [sev.HINT]  = "H",
        },
    },

    float            = { source = true }, -- рамку даёт 'winborder'
    jump             = { float = true },  -- ]d / [d сразу показывают текст
})

-- Переключить «шумный» режим: virtual_text на всех строках ↔ только под курсором
vim.api.nvim_create_user_command("DiagnosticsVerbose", function()
    local cur = vim.diagnostic.config().virtual_text
    vim.diagnostic.config({
        virtual_text = cur and false or { prefix = "●", spacing = 4 },
    })
end, { desc = "Diagnostics: virtual_text вкл/выкл" })
