return {
    {
        "rebelot/kanagawa.nvim",
        config = function()
            require("kanagawa").setup({
                theme = "wave",
            })

            vim.cmd("colorscheme kanagawa")
        end,
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        config = function()
            require("noice").setup({
                lsp = {
                    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
                    },
                },
                -- you can enable a preset for easier configuration
                presets = {
                    bottom_search = true,         -- use a classic bottom cmdline for search
                    command_palette = true,       -- position the cmdline and popupmenu together
                    long_message_to_split = true, -- long messages will be sent to a split
                    inc_rename = false,           -- enables an input dialog for inc-rename.nvim
                    lsp_doc_border = true,        -- add a border to hover docs and signature help
                },
            })
            require("notify").setup({
                background_colour = "#000000",
            })
        end,
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require("lualine").setup(
                {
                    options = {
                        theme = "auto",
                    }
                }
            )
        end
    },
    {
        'goolord/alpha-nvim',
        dependencies = {
            'echasnovski/mini.icons',
            'nvim-lua/plenary.nvim'
        },
        config = function()
            require 'alpha'.setup(require 'alpha.themes.theta'.config)
        end
    },
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
        'akinsho/toggleterm.nvim',
        version = "*",
        opts = {
            size = function(term)
                if term.direction == "horizontal" then
                    return 15
                elseif term.direction == "vertical" then
                    return vim.o.columns * 0.4
                end
            end,
            open_mapping = [[<c-\>]],
            direction = 'vertical',
        }
    }
}
