-- plugins/telescope.lua:
return {
    {
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
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            local harpoon = require("harpoon")

            -- REQUIRED
            harpoon:setup()
            -- REQUIRED

            vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
            vim.keymap.set("n", "<C-m>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

            vim.keymap.set("n", "<C-q>", function() harpoon:list():select(1) end)
            vim.keymap.set("n", "<C-w>", function() harpoon:list():select(2) end)
            vim.keymap.set("n", "<C-e>", function() harpoon:list():select(3) end)
            vim.keymap.set("n", "<C-r>", function() harpoon:list():select(4) end)

            -- Toggle previous & next buffers stored within Harpoon list
            vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
            vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
        end
    }
}
