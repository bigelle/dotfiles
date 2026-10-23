-- =============================================================================
-- CONFNAV — быстрый заход в конфиг и возврат обратно
--
--   :Conf              выбрать файл конфига из списка
--   :Conf keymaps      открыть lua/config/keymaps.lua (есть Tab-дополнение)
--   :ConfBack          сохранить всё → перезапустить nvim → вернуться в файл,
--                      из которого пришёл, на ту же строку и колонку
--   :ConfBack!         то же, но без перезапуска (просто прыжок назад)
--   :ConfRestart       перезапуск на месте, с восстановлением текущего файла
--
-- Точка возврата переживает перезапуск: она пишется на диск в
-- stdpath('state')/confnav.json и читается на VimEnter.
-- =============================================================================

local M              = {}

local CONFIG         = vim.fn.stdpath("config")
local STATEDIR       = vim.fn.stdpath("state")
local MARK           = vim.fs.joinpath(STATEDIR, "confnav.json")

--- Директория исходников chezmoi, где лежит конфиг nvim (например: ~/.local/share/chezmoi/dot_config/nvim)
local CHEZMOI_SOURCE = (function()
    local res = vim.fn.systemlist({ "chezmoi", "source-path", CONFIG })
    if vim.v.shell_error == 0 and res[1] then
        return vim.fs.normalize(res[1])
    end
    return nil
end)()

-- ── вспомогательное ──────────────────────────────────────────────────────────

local function is_config_file(path)
    if path == "" then return false end
    local norm = vim.fs.normalize(path)
    local in_target = norm:sub(1, #CONFIG) == CONFIG
    local in_source = CHEZMOI_SOURCE and (norm:sub(1, #CHEZMOI_SOURCE) == CHEZMOI_SOURCE)
    return in_target or in_source
end

--- Список .lua-файлов конфига из chezmoi source, с человекочитаемыми путями
local function config_files()
    local root = CHEZMOI_SOURCE or CONFIG
    local found = vim.fs.find(function(name, path)
        return name:match("%.lua$")
            and not path:match("/%.git")
            and not path:match("/pack/")
    end, { path = root, type = "file", limit = math.huge })

    local rel = vim.tbl_map(function(p)
        local rel_path = vim.fs.normalize(p):gsub("^" .. vim.pesc(root) .. "/", "")
        -- Убираем специфичные префиксы chezmoi для удобства вывода (dot_ -> .)
        return rel_path
    end, found)
    table.sort(rel)
    return rel
end

--- Применить изменения chezmoi для конфига Neovim
local function chezmoi_apply()
    local res = vim.fn.systemlist({ "chezmoi", "apply", CONFIG })
    if vim.v.shell_error ~= 0 then
        vim.notify("Ошибка chezmoi apply:\n" .. table.concat(res, "\n"), vim.log.levels.ERROR)
        return false
    end
    return true
end

--- Запомнить, откуда пришли (и на диск — чтобы пережить :restart)
function M.remember()
    local buf = vim.api.nvim_get_current_buf()
    local file = vim.api.nvim_buf_get_name(buf)
    if file == "" or vim.bo[buf].buftype ~= "" or is_config_file(file) then
        return -- из конфига в конфиг — точку возврата не перетираем
    end

    local pos = vim.api.nvim_win_get_cursor(0)

    local bufs = {}
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
        local name = vim.api.nvim_buf_get_name(b)
        if vim.bo[b].buflisted and vim.bo[b].buftype == "" and name ~= "" and not is_config_file(name) then
            table.insert(bufs, name)
        end
    end

    M.origin = { file = file, lnum = pos[1], col = pos[2], cwd = vim.fn.getcwd(), buffers = bufs }
end

local function write_mark()
    if not M.origin then return false end
    local ok, json = pcall(vim.json.encode, M.origin)
    if not ok then return false end
    local fd = io.open(MARK, "w")
    if not fd then return false end
    fd:write(json)
    fd:close()
    return true
end

local function read_mark()
    local fd = io.open(MARK, "r")
    if not fd then return nil end
    local content = fd:read("*a")
    fd:close()
    os.remove(MARK)
    local ok, data = pcall(vim.json.decode, content)
    return ok and data or nil
end

local function jump_to(data)
    if not data or not data.file then return end
    if data.cwd and vim.fn.isdirectory(data.cwd) == 1 then pcall(vim.cmd.cd, data.cwd) end
    for _, name in ipairs(data.buffers or {}) do
        if name ~= data.file and vim.uv.fs_stat(name) then
            pcall(vim.cmd.badd, vim.fn.fnameescape(name))
        end
    end
    vim.cmd.edit(vim.fn.fnameescape(data.file))
    pcall(vim.api.nvim_win_set_cursor, 0, { data.lnum or 1, data.col or 0 })
    vim.cmd("normal! zz")
end

local function restart(reason)
    vim.cmd("silent! wall")

    -- Выполняем chezmoi apply перед рестартом
    if not chezmoi_apply() then
        return false
    end

    if vim.fn.exists(":restart") ~= 2 then
        vim.notify(":restart недоступен в этом UI — перезапусти nvim вручную", vim.log.levels.WARN)
        return false
    end
    vim.schedule(function() vim.cmd("restart") end)
    if reason then vim.notify(reason) end
    return true
end

-- ── :Conf ────────────────────────────────────────────────────────────────────

vim.api.nvim_create_user_command("Conf", function(opts)
    if not CHEZMOI_SOURCE then
        vim.notify("chezmoi source path не найден для " .. CONFIG, vim.log.levels.ERROR)
        return
    end

    M.remember()

    local root = CHEZMOI_SOURCE

    if opts.args ~= "" then
        -- Поддержка ввода как относительного пути с обычными именами
        local target_arg = opts.args:gsub("^%./", "")

        -- Сначала ищем прямое совпадение
        local path = vim.fs.joinpath(root, target_arg)
        if not vim.uv.fs_stat(path) then
            -- Пробуем найти файл с учетом префиксов chezmoi (например dot_)
            local files = config_files()
            for _, f in ipairs(files) do
                if f == target_arg or f:find(target_arg, 1, true) then
                    -- Находим реальный путь на диске
                    local found = vim.fs.find(function(name)
                        return name:match("%.lua$")
                    end, { path = root, type = "file", limit = math.huge })

                    for _, real_p in ipairs(found) do
                        if real_p:match(target_arg .. "$") then
                            path = real_p
                            break
                        end
                    end
                    break
                end
            end
        end

        if vim.uv.fs_stat(path) then
            vim.cmd.edit(vim.fn.fnameescape(path))
        else
            vim.notify("нет такого файла в chezmoi: " .. opts.args, vim.log.levels.ERROR)
        end
        return
    end

    local choices = config_files()
    vim.ui.select(choices, { prompt = "Конфиг (Chezmoi):" }, function(choice)
        if choice then
            local found = vim.fs.find(function(name, path)
                return (path .. "/" .. name):match(choice:gsub("%.", "%%.") .. "$")
            end, { path = root, type = "file" })

            if found[1] then
                vim.cmd.edit(vim.fn.fnameescape(found[1]))
            end
        end
    end)
end, {
    nargs = "?",
    desc = "Открыть файл конфига из chezmoi source",
    complete = function(lead)
        return vim.tbl_filter(function(f) return f:find(lead, 1, true) == 1 end, config_files())
    end,
})
-- ── :ConfBack ────────────────────────────────────────────────────────────────

vim.api.nvim_create_user_command("ConfBack", function(opts)
    if not M.origin then
        vim.notify("точка возврата не задана (зайди через :Conf)", vim.log.levels.WARN)
        return
    end

    if opts.bang then -- без перезапуска, но применяем chezmoi
        vim.cmd("silent! wall")
        chezmoi_apply()
        jump_to(M.origin)
        M.origin = nil
        return
    end

    if write_mark() then
        restart("применение chezmoi и перезапуск…")
    end
end, { bang = true, desc = "Применить chezmoi и вернуться туда, откуда зашел" })

-- ── :ConfRestart ─────────────────────────────────────────────────────────────

vim.api.nvim_create_user_command("ConfRestart", function()
    M.remember() -- если сейчас в обычном файле — вернёмся сюда же
    write_mark()
    restart("применение chezmoi и перезапуск…")
end, { desc = "Применить chezmoi и перезапустить nvim" })

-- ── восстановление после :restart ────────────────────────────────────────────

vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("confnav_restore", { clear = true }),
    nested = true,
    callback = function()
        local data = read_mark()
        if not data then return end
        if vim.fn.argc() > 0 then return end
        vim.schedule(function() jump_to(data) end)
    end,
})

return M
