local icons = require("dvim.icons")
local kind_icons = icons.kind

local opt = {
    formatting = {
        source_names = {},
    }
}

return {
    name = 'nvim-cmp',
    dir = "/work/ddcien/nvim-cmp",
    dependencies = {
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        {
            'hrsh7th/cmp-nvim-lsp',
            dependencies = "neovim/nvim-lspconfig",
        },
        {
            'saadparwaiz1/cmp_luasnip',
            dependencies = "L3MON4D3/LuaSnip",
        },
        {
            'quangnguyen30192/cmp-nvim-ultisnips',
            dependencies = "SirVer/ultisnips",
        }
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<c-Space>'] = cmp.mapping.complete(),
                ['<CR>'] = cmp.mapping.confirm({ select = false }),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    elseif cmp.visible() then
                        cmp.select_next_item()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    elseif cmp.visible() then
                        cmp.select_prev_item()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),
            sources = cmp.config.sources(
                {
                    { name = 'nvim_lsp' },
                },
                {
                    { name = 'ultisnips' },
                    { name = 'luasnip', },
                },
                {
                    { name = 'buffer' },
                    { name = 'path' },
                }),
            matching = {
                disallow_fuzzy_matching = false, -- fmodify -> fnamemodify
                disallow_fullfuzzy_matching = true,
                disallow_partial_fuzzy_matching = true,
                disallow_partial_matching = false, -- fb -> foo_bar
                disallow_prefix_unmatching = true, -- bar -> foo_bar
            },
            confirm_opts = {
                behavior = cmp.ConfirmBehavior.Replace,
                select = false,
            },
            experimental = {
                ghost_text = false,
            },
            -- view = { entries = { name = "native", }, },
            preselect = cmp.PreselectMode.None,
            performance = {
                debounce = 50,
                throttle = 20,
                confirm_resolve_timeout = 50,
                async_budget = 1,
                fetching_timeout = 200,
                max_view_entries = 50,
            },
            completion = {
                autocomplete = {
                    'InsertEnter',
                    'TextChanged'
                },
                keyword_length = 1,
            },
            -- window = {
            --     completion = cmp.config.window.bordered(),
            --     documentation = cmp.config.window.bordered(),
            -- },
            formatting = {
                expandable_indicator = true,
                fields = { "kind", "abbr", "menu" },
                format = function(entry, vim_item)
                    -- kind
                    vim_item.kind = kind_icons[vim_item.kind]
                    -- menu
                    if entry.source.name == "nvim_lsp" then
                        vim_item.menu = entry.source.source.client.name
                    else
                        vim_item.menu = opt.formatting.source_names[entry.source.name] or entry.source.name
                    end
                    return vim_item
                end,
            },
        })
    end,
}
