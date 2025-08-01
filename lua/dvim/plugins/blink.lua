local icons = require("dvim.icons")
local kind_icons = icons.kind

return {
    'saghen/blink.cmp',
    version = '1.*',

    dependencies = {
        'moyiz/blink-emoji.nvim',
        'rafamadriz/friendly-snippets',
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
                selection = { preselect = false, auto_insert = true },
            },
            menu = {
                auto_show = true,
                -- border = 'single',
                draw = {
                    components = {
                        source_name = {
                            width = { max = 30 },
                            text = function(ctx)
                                if (ctx.item.client_id) then
                                    local client = vim.lsp.get_client_by_id(ctx.item.client_id)
                                    assert(client)
                                    return "LSP: " .. client.name
                                end
                                return ctx.source_name
                            end,
                            highlight = 'BlinkCmpSource',
                        },
                    },
                    columns = {
                        { 'kind_icon' },
                        { 'label',      'label_description', gap = 1 },
                        { "source_name" }
                    },
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
        signature = { enabled = true, window = { border = 'single', show_documentation = false, } },
        keymap = { preset = 'default', },

        appearance = {
            use_nvim_cmp_as_default = false,
            nerd_font_variant = 'mono',
            kind_icons = kind_icons,
        },

        cmdline = {
            enabled = false,
        },
        sources = {
            default = { 'snippets', 'lsp', 'path', 'buffer' },
            per_filetype = {
                markdown = { 'lsp', 'snippets', 'path', 'buffer', 'emoji', },
                gitcommit = { 'lsp', 'snippets', 'path', 'buffer', 'emoji', },
            },
            -- cmdline = {},
            providers = {
                lsp = {
                    transform_items = function(_, items)
                        return items
                    end,
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
