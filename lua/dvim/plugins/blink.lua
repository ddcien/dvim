local icons = require("dvim.icons")
local kind_icons = icons.kind

return {
    'saghen/blink.cmp',
    version = '*',
    dependencies = {
        'rafamadriz/friendly-snippets',
        'mikavilpas/blink-ripgrep.nvim',
        'moyiz/blink-emoji.nvim',
    },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        completion = {
            keyword = {
                range = 'prefix', -- 'prefix' or 'full'
            },
            trigger = {
                prefetch_on_insert = true,
                show_on_keyword = true,
                show_on_trigger_character = true,
                show_on_insert_on_trigger_character = true,
                show_on_accept_on_trigger_character = true,
            },
            list = {
                selection = 'auto_insert',
            },
            menu = {
                auto_show = true,
                -- border = 'single',
                draw = {
                    columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 }, },
                    treesitter = { 'lsp' }
                }
            },
            ghost_text = {
                enabled = false,
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 500,
                treesitter_highlighting = true,
                -- window = { border = 'single' }
            },
        },
        signature = {
            enabled = true,
            window = { border = 'single' }
        },
        keymap = {
            preset = 'default',
        },
        appearance = {
            use_nvim_cmp_as_default = false,
            nerd_font_variant = 'mono',
            kind_icons = kind_icons,
        },
        sources = {
            default = { 'lsp', 'snippets', 'path', 'buffer', },
            per_filetype = {
                markdown = { 'lsp', 'snippets', 'path', 'buffer', 'emoji', },
                gitcommit = { 'lsp', 'snippets', 'path', 'buffer', 'emoji', },
            },
            cmdline = {},
            providers = {
                ripgrep = {
                    module = "blink-ripgrep",
                    name = "Ripgrep",
                    opts = {
                        prefix_min_len = 5,
                    },
                },
                emoji = {
                    module = "blink-emoji",
                    name = "Emoji",
                    score_offset = 15,
                }
            },
        },
    },
    opts_extend = { "sources.default" }
}
