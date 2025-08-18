return {
    {
        "saghen/blink.cmp",
        version = '1.*',
        event = "InsertEnter",
        opts_extend = {
            -- "sources.completion.enabled_providers",
            -- "sources.compat",
            "sources.default",
        },
        dependencies = {
            'moyiz/blink-emoji.nvim',
            "rafamadriz/friendly-snippets",
        },

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            -- snippets = {
            --     expand = function(snippet, _)
            --         return LazyVim.cmp.expand(snippet)
            --     end,
            -- },
            appearance = {
                use_nvim_cmp_as_default = false,
                nerd_font_variant = "mono",
            },
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
                accept = {
                    -- experimental auto-brackets support
                    auto_brackets = {
                        enabled = true,
                    },
                },
                menu = {
                    auto_show = true,
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
                        treesitter = { "lsp" },
                    },
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 500,
                    treesitter_highlighting = true,
                    window = { border = 'single' }
                },
                ghost_text = {
                    enabled = false,
                },
            },
            signature = {
                enabled = true,
                window = {
                    border = 'single',
                    show_documentation = false,
                },
            },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },
            cmdline = {
                enabled = false,
            },
            keymap = {
                preset = "enter",
                ["<C-y>"] = { "select_and_accept" },
            },
        },
    },
}
