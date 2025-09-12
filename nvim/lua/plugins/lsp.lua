return {
    {
        "neovim/nvim-lspconfig",
        config = function()
            vim.lsp.enable({
                "gopls",
                "lua_ls"
            })
        end
    },
}
