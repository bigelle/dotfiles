vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*", -- Apply to all file types, or specify pattern for specific file types (e.g., "*.lua")
    callback = function(args)
        -- Check if LSP clients are attached and capable of formatting
        local clients = vim.lsp.get_active_clients({ bufnr = args.buf })
        for _, client in ipairs(clients) do
            if client.server_capabilities.documentFormattingProvider or client.server_capabilities.documentRangeFormattingProvider then
                vim.lsp.buf.format({ bufnr = args.buf, async = false }) -- async = false ensures formatting completes before saving
                break                                                   -- Format with the first capable client found
            end
        end
    end,
})
