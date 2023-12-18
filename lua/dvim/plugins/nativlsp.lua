local core_plugins = {
    --------------------
    { "j-hui/fidget.nvim", opts = {}, },
    {
        "neovim/nvim-lspconfig",
        config = require("dvim.configs.lsp").setup,
        dependencies = {
            "hrsh7th/nvim-cmp",
            "nvim-telescope/telescope.nvim",
        },
    },
    {
        "folke/trouble.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons"
        },
        opts = {},
        cmd = {
            "TroubleToggle"
        }
    },


    ---
    {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
            "SmiteshP/nvim-navic",
            "MunifTanjim/nui.nvim"
        },
        opts = { lsp = { auto_attach = true } }
    },
    {
        "SmiteshP/nvim-navic",
        opts = {},
    },
    {
        "hrsh7th/nvim-cmp",
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    -- REQUIRED - you must specify a snippet engine
                    expand = function(args)
                        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                        vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
                    end,
                },
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    -- { name = 'vsnip' }, -- For vsnip users.
                    -- { name = 'luasnip' }, -- For luasnip users.
                    { name = 'ultisnips' }, -- For ultisnips users.
                    -- { name = 'snippy' }, -- For snippy users.
                }, {
                    { name = 'buffer' },
                    { name = 'path' },
                    { name = 'look' },
                }),
                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    max_width = 0,
                },
                mapping = cmp.mapping.preset.insert({
                }),
            }
            )
        end,
        dependencies = {
            { "neovim/nvim-lspconfig", },
            { "hrsh7th/cmp-nvim-lsp",                lazy = true },
            { "hrsh7th/cmp-buffer",                  lazy = true },
            { "hrsh7th/cmp-path",                    lazy = true },
            { "hrsh7th/cmp-cmdline",                 lazy = true },
            { "octaltree/cmp-look",                  lazy = true },
            -- { 'hrsh7th/cmp-vsnip',                   lazy = true },
            -- { 'hrsh7th/vim-vsnip',                   lazy = true },
            -- { 'L3MON4D3/LuaSnip',                    lazy = true },
            -- { 'saadparwaiz1/cmp_luasnip',            lazy = true },
            { 'SirVer/ultisnips',                    lazy = true },
            { 'quangnguyen30192/cmp-nvim-ultisnips', lazy = true },
        },
        event = { "InsertEnter", "CmdlineEnter" },
        lazy = true,
    },
}

return core_plugins
