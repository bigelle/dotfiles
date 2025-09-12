local function setup_keymaps()
    -- Telescope
    local builtin = require('telescope.builtin')

    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
    vim.keymap.set('n', '<leader>xx', builtin.diagnostics, { desc = 'Telescope diagnostics' })

    -- Neotree
    vim.keymap.set('n', '<leader>nt', "<Cmd>Neotree toggle<CR>", { desc = 'Neotree Toggle' })

    -- LSP
    vim.keymap.set("n", "<leader>fd", "<Cmd>lua vim.lsp.buf.format()<CR>", { silent = true })
    vim.keymap.set("n", "<leader>gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", { silent = true })
    vim.keymap.set("n", "<leader>ro", "<Cmd>lua vim.lsp.buf.rename()<CR>", { silent = true })
    vim.keymap.set("n", "<leader>ca", "<Cmd>lua vim.lsp.buf.code_action()<CR>", { silent = true })
end

-- Commands
local function go_modify_tags()
    vim.ui.input({ prompt = "Enter tags (e.g. json db): " }, function(input)
        if not input or input == "" then
            print("🚫 No tags entered. Cancelled.")
            return
        end

        vim.api.nvim_command("write")

        local bufnr = vim.api.nvim_get_current_buf()
        local filename = vim.api.nvim_buf_get_name(bufnr)

        local cursor = vim.api.nvim_win_get_cursor(0)
        local row = cursor[1] - 1
        local col = cursor[2]

        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        local offset = 0
        for i = 0, row - 1 do
            offset = offset + #lines[i + 1] + 1
        end
        offset = offset + col

        local cmd = {
            "gomodifytags",
            "-file", filename,
            "-offset", tostring(offset),
            "-add-tags", input,
            "-w"
        }

        vim.fn.jobstart(cmd, {
            stdout_buffered = true,
            stderr_buffered = true,
            on_exit = function(_, code)
                if code == 0 then
                    vim.cmd("edit!")
                    print("✅ Tags added: " .. input)
                else
                    print("❌ Failed to add tags.")
                end
            end
        })
    end)
end

setup_keymaps()
vim.api.nvim_create_user_command("GoModifyTags", go_modify_tags, {})
