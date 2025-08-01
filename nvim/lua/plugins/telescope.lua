-- plugins/telescope.lua:
return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    -- or                              , branch = '0.1.x',
    dependenacies = { 'nvim-lua/plenary.nvim' },
    config = function()
        require("telescope").setup({
            defaults = {
                no_ignore = true,
            },
            pickers = {
                find_files = {
                    no_ignore = true,
                },

                live_grep = {
                    mappings = {
                        i = {
                            ["<CR>"] = function(prompt_bufnr)
                                require("telescope.actions").select_default(prompt_bufnr)
                                vim.schedule(function()
                                    vim.cmd("normal! zz")
                                end)
                            end,
                        },
                    },
                },
            }
        })
    end
}
