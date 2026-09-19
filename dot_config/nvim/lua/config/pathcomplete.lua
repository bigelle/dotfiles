-- Источник путей для 'complete'. Интерфейс — :h complete-functions.
local M = {}

function M.complete(findstart, base)
    if findstart == 1 then
        local col   = vim.fn.col(".") - 1
        local line  = vim.api.nvim_get_current_line():sub(1, col)
        local start = line:find("[%w%._%-~/%$]*$")
        -- срабатываем только если под курсором похоже на путь
        if not line:sub(start, col):find("/") then
            return -3 -- отменить тихо, меню не показывать
        end
        return start - 1
    end
    return vim.fn.getcompletion(base, "file")
end

_G.PathComplete = M.complete

return M
