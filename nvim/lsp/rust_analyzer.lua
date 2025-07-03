return {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = { "Cargo.toml" },
    settings = {
        ["rust-analyzer"] = {
            rustfmt = {
                extraArgs = {},
            },
        },
    },
}
