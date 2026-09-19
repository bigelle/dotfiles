-- Файлы в ~/.config/nvim/lsp/ автоматически подхватываются vim.lsp.enable()
-- и мержатся поверх конфига из nvim-lspconfig.
return {
    settings = {
        Lua = {
            diagnostics = { globals = { "vim", "MiniIcons" } },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = { enable = false },
            hint = { enable = true }, -- inlay hints, включаются по <leader>lh
        },
    },
}
