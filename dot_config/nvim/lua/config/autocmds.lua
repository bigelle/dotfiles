-- =============================================================================
-- AUTOCMDS
-- =============================================================================

local aug = vim.api.nvim_create_augroup("user_autocmds", { clear = true })

-- Подсветка скопированного текста
vim.api.nvim_create_autocmd("TextYankPost", {
    group = aug,
    desc = "Подсветить yank",
    callback = function() vim.hl.on_yank() end,
})

-- Treesitter: подсветка не включается сама (ветка main), плюс доставляем
-- недостающий парсер на лету — один раз на язык.
local function ts_start(buf, lang)
    if not pcall(vim.treesitter.start, buf, lang) then return end
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end

vim.api.nvim_create_autocmd("FileType", {
    group = aug,
    desc = "Включить/доставить treesitter для буфера",
    callback = function(args)
        local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
        if not lang then return end

        -- парсер уже есть
        if vim.treesitter.language.add(lang) then
            ts_start(args.buf, lang)
            return
        end

        -- нет — ставим, если такой вообще существует
        local ok, ts_config = pcall(require, "nvim-treesitter.config")
        if not ok or not vim.tbl_contains(ts_config.get_available(), lang) then return end

        require("nvim-treesitter").install({ lang }):await(function(err)
            if err then return end
            vim.schedule(function()
                if vim.api.nvim_buf_is_valid(args.buf) then ts_start(args.buf, lang) end
            end)
        end)
    end,
})

-- Вернуть курсор на место при повторном открытии файла
vim.api.nvim_create_autocmd("BufReadPost", {
    group = aug,
    desc = "Восстановить позицию курсора",
    callback = function(args)
        local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
        if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(args.buf) then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- В терминале не нужны номера строк
vim.api.nvim_create_autocmd("TermOpen", {
    group = aug,
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
    end,
})
