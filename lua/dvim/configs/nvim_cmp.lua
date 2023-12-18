local icons = require("dvim.icons")

local M = {
    formatting = {
        source_names = {
            nvim_lsp = "(LSP)",
            path = "(Path)",
            buffer = "(Buffer)",
        },
        duplicates = {
            buffer = 1,
            path = 1,
            nvim_lsp = 0,
        },
        duplicates_default = 0,
    }
}

M.setup = function()
    -- nvim-cmp setup
    local cmp = require("cmp")
    local cmp_window = require("cmp.config.window")
    local cmp_mapping = require("cmp.config.mapping")

    cmp.setup({
        snippet = {
            expand = function(args)
                -- vim.fn["UltiSnips#Anon"](args.body)
                require('luasnip').lsp_expand(args.body)
            end,
        },
        window = {
            completion = cmp_window.bordered(),
            documentation = cmp_window.bordered(),
        },
        sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'ultisnips' },
            { name = 'buffer' },
        }, {
            { name = "path" },
            { name = "look" },
        }),
        mapping = cmp_mapping.preset.insert({
            ['<C-Space>'] = cmp.mapping.complete(),
        }),
    })
end

return M
