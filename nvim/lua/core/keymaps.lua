-- Telescope
local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<leader>xx', builtin.diagnostics, { desc = 'Telescope diagnostics' })

-- LSP
vim.keymap.set("n", "<leader>fd", "<Cmd>lua vim.lsp.buf.format()<CR>", { silent = true })
vim.keymap.set("n", "<leader>gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", { silent = true })
vim.keymap.set("n", "<leader>ro", "<Cmd>lua vim.lsp.buf.rename()<CR>", { silent = true })
vim.keymap.set("n", "<leader>ca", "<Cmd>lua vim.lsp.buf.code_action()<CR>", { silent = true })
