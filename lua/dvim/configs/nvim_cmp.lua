local icons = require("dvim.icons")

local M = {
    formatting = {
        source_names = {
            nvim_lsp = "(LSP)",
            path = "(Path)",
            calc = "(Calc)",
            luasnip = "(Snippet)",
            buffer = "(Buffer)",
            treesitter = "(TreeSitter)",
        },
        duplicates = {
            buffer = 1,
            path = 1,
            nvim_lsp = 0,
            luasnip = 1,
        },
        duplicates_default = 0,
    }
}

M.setup = function()
    -- luasnip setup
    local luasnip = require('luasnip')

    -- nvim-cmp setup
    local cmp = require("cmp")
    local cmp_window = require("cmp.config.window")
    local cmp_mapping = require("cmp.config.mapping")

    cmp.setup({
        snippet = {
            expand = function(args)
                print(vim.inspect(args))
                luasnip.lsp_expand(args.body)
            end,
        },
        window = {
            completion = cmp_window.bordered(),
            documentation = cmp_window.bordered(),
        },
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'ultisnips' },

        }, {
            { name = 'buffer' },
            { name = "path" },
            { name = "look" },
            { name = 'calc' },
        }),
        mapping = cmp_mapping.preset.insert({
            ['<C-Space>'] = cmp.mapping.complete(),
        }),
        formatting = {
            fields = { "kind", "abbr", "menu" },
            max_width = 0,

            format = function(entry, vim_item)
                local max_width = 60
                local kind_icons = icons.kind

                if max_width ~= 0 and #vim_item.abbr > max_width then
                    vim_item.abbr = string.sub(vim_item.abbr, 1, max_width - 1) .. icons.ui.Ellipsis
                end

                vim_item.kind = kind_icons[vim_item.kind]
                vim_item.menu = M.formatting.source_names[entry.source.name] or entry.source.name
                vim_item.dup = M.formatting.duplicates[entry.source.name] or M.formatting.duplicates_default
                return vim_item
            end,
        },
    })
end

return M
