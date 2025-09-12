return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            triggers = {},

            plugins = {
                spelling = {
                    enabled = false,
                },
            },
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ mode = 'n' })
                end,
                desc = "Show Which-Key manually",
            },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        branch = "master",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                ensure_installed = { "lua", "vimdoc", "go", "rust" },
                auto_install = true,
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    },
    {
        "kdheepak/lazygit.nvim",
        lazy = true,
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        -- optional for floating window border decoration
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        -- setting the keybinding for LazyGit with 'keys' is recommended in
        -- order to load the plugin when the command is run for the first time
        keys = {
            { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
        },
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",     -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            -- Optional image support for file preview: See `# Preview Mode` for more information.
            -- {"3rd/image.nvim", opts = {}},
            -- OR use snacks.nvim's image module:
            -- "folke/snacks.nvim",
        },
        lazy = false,     -- neo-tree will lazily load itself
        opts = {
            filesystem = {
                filtered_items = {
                    hide_gitignored = false,
                }
            }
        }
    },
    {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "VeryLazy",     -- Or `LspAttach`
        priority = 1000,        -- needs to be loaded in first
        config = function()
            require('tiny-inline-diagnostic').setup({
                options = {
                    use_icons_from_diagnostic = true,
                    throttle = 0,
                    multilines = {
                        enabled = true,
                        always_show = true,
                    },
                    show_all_diags_on_cursorline = true,
                    enable_on_insert = true,
                    enable_on_select = true,
                },
            })
            vim.diagnostic.config({ virtual_text = false })     -- Only if needed in your configuration, if you already have native LSP diagnostics
        end
    }
}
