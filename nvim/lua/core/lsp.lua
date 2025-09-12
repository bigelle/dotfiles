vim.diagnostic.config({
    virtual_text = false,
    virtual_lines = false,
    float = {
        border = "rounded",
        wrap = true,
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN]  = "󰀪 ",
            [vim.diagnostic.severity.INFO]  = "󰋽 ",
            [vim.diagnostic.severity.HINT]  = "󰌶 ",
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "ErrorMsg",
            [vim.diagnostic.severity.WARN]  = "WarningMsg",
        },
    },
})

vim.lsp.config('gopls', {
    settings = {
        gopls = {
            gofumpt = true,
            codelenses = {
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
            },
            analyses = {
                nilness        = true,
                unusedparams   = true,
                unusedwrite    = true,
                unreachable    = true,
                shadow         = true,
                copylocks      = true,
                loopclosure    = true,
                lostcancel     = true,
                httpresponse   = true,
                printf         = true,
                errorsas       = true,
                composites     = true,
                simplifyrange  = true,
                simplifyslice  = true,
                structtag      = true,
                waitgroup      = true,
                unmarshal      = true,
                unsafeptr      = true,
                unusedresult   = true,
                unusedvariable = true,
                deprecated     = true,
            },
            completeUnimported = true,
        },
    }
})

