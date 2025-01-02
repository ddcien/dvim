return {
    {
        "monkoose/neocodeium",
        enabled = false,
        event = "VeryLazy",
        config = function()
            local neocodeium = require("neocodeium")
            neocodeium.setup()
            vim.keymap.set("i", "<A-f>", neocodeium.accept)
            vim.keymap.set("i", "<A-w>", neocodeium.accept_word)
            vim.keymap.set("i", "<A-a>", neocodeium.accept_line)
            vim.keymap.set("i", "<A-e>", neocodeium.cycle_or_complete)
            vim.keymap.set("i", "<A-r>", function() neocodeium.cycle_or_complete(-1) end)
            vim.keymap.set("i", "<A-c>", neocodeium.clear)
        end,
    },
    {
        "zbirenbaum/copilot.lua",
        enabled = false,
        cmd = "Copilot",
        event = "InsertEnter",
        opts = {},
        dependencies = {
            { 'AndreM222/copilot-lualine' }
        }
    },
    {
        "yetone/avante.nvim",
        enabled = false,
        event = "VeryLazy",
        lazy = false,
        version = false, -- set this if you want to always pull the latest change
        opts = {
            -- add any opts here
        },
        -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
        build = "make",
        -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
        dependencies = {
            "stevearc/dressing.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            --- The below dependencies are optional,
            "hrsh7th/nvim-cmp",            -- autocompletion for avante commands and mentions
            "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
            "zbirenbaum/copilot.lua",      -- for providers='copilot'
            {
                -- support for image pasting
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
                opts = {
                    -- recommended settings
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                        -- required for Windows users
                        use_absolute_path = true,
                    },
                },
            },
            {
                -- Make sure to set this up properly if you have lazy=true
                'MeanderingProgrammer/render-markdown.nvim',
                opts = {
                    file_types = { "markdown", "Avante" },
                },
                ft = { "markdown", "Avante" },
            },
        },
    },
    {
        "olimorris/codecompanion.nvim",
        enabled = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            {
                'MeanderingProgrammer/render-markdown.nvim',
                opts = {
                    file_types = { "markdown", "Avante", "codecompanion" },
                },
                ft = { "markdown", "Avante", "codecompanion" },
            },
        },
        opts = {
            language = "Chinese" -- Default is "English"
        },
        config = true
    },
}
