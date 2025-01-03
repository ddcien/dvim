local plugins = {
    { -- lazy.nvim
        'folke/lazy.nvim',
        tag = 'stable'
    },
    { -- telescope
        'nvim-telescope/telescope.nvim',
        -- branch = '0.1.x',
        event = 'VimEnter',
        dependencies = {
            'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' },
            'nvim-treesitter/nvim-treesitter',
            'nvim-tree/nvim-web-devicons',
            'nvim-telescope/telescope-ui-select.nvim',
        },
        config = function()
            local telescope = require('telescope')
            local actions = require('telescope.actions')
            local builtin = require('telescope.builtin')
            telescope.load_extension('fzf')
            telescope.load_extension('ui-select')
            require('telescope').setup {
                defaults = {
                    dynamic_preview_title = true,
                    mappings = {
                        i = {
                            ['<C-j>'] = actions.move_selection_next,
                            ['<C-k>'] = actions.move_selection_previous,
                        },
                    },
                },
                extensions = {
                    ['fzf'] = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = 'smart_case',
                    },
                    ['ui-select'] = {
                        require('telescope.themes').get_dropdown(),
                    },
                },
            }
            vim.keymap.set('n', '<c-p>', builtin.find_files, { noremap = true, silent = true })
            vim.api.nvim_create_user_command(
                'Rg',
                function(args)
                    if string.len(args.args) == 0 then
                        builtin.grep_string()
                    else
                        builtin.grep_string({ search = args.args })
                    end
                end,
                { nargs = '?' }
            )
            vim.api.nvim_create_autocmd('User', {
                pattern = 'TelescopePreviewerLoaded',
                callback = function()
                    vim.wo.number = true
                end,
            })
        end,
    },
    { -- treesitter
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        event = { 'VeryLazy' },
        cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
        opts = function()
            return {
                sync_install = false,
                auto_install = false,
                ensure_installed = {
                    'bash', 'c', 'cpp', 'cmake', 'comment', 'devicetree', 'diff',
                    'dockerfile', 'gitcommit', 'gitignore', 'json', 'jsonc',
                    'json', 'jsonc', 'lua', 'make', 'markdown', 'markdown_inline',
                    'python', 'query', 'rust', 'verilog', 'vimdoc', 'vim', 'yaml',
                    'gitcommit'
                },
                highlight = { enable = true },
                indent = { enable = true },
                matchup = {
                    enable = false,
                    disable = { 'c', 'cpp' },
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = '<C-space>',
                        node_incremental = '<C-space>',
                        scope_incremental = false,
                        node_decremental = '<bs>',
                    },
                },
            }
        end,
        config = function(_, opts)
            if type(opts.ensure_installed) == 'table' then
                local added = {}
                opts.ensure_installed = vim.tbl_filter(function(lang)
                    if added[lang] then
                        return false
                    end
                    added[lang] = true
                    return true
                end, opts.ensure_installed)
            end
            require('nvim-treesitter.configs').setup(opts)
        end,
    },
    { -- nvim-tree.lua
        'nvim-tree/nvim-tree.lua',
        config = function()
            require('nvim-tree').setup({
                on_attach = function(bufnr)
                    require('nvim-tree.api').config.mappings.default_on_attach(bufnr)
                    vim.keymap.del('n', '<c-e>', { buffer = bufnr })
                end
            })
            vim.keymap.set('n', '<c-e>', '<cmd>NvimTreeToggle<cr>', { noremap = true, silent = true })
        end
    },
    { -- markdown
        {
            'iamcco/markdown-preview.nvim',
            cmd = { 'MarkdownPreview' },
            ft = { 'markdown' },
            build = function() vim.fn['mkdp#util#install']() end,
            init = function()
                vim.g.mkdp_filetypes = { 'markdown' }
                vim.g.mkdp_preview_options = {
                    disable_filename = true
                }
            end,
        },
        {
            'HakonHarnes/img-clip.nvim',
            event = 'VeryLazy',
            ft = { 'markdown' },
            opts = {
            },
        },
    },

    { -- misc
        { 'kevinhwang91/nvim-bqf',    ft = { 'qf' } },
        { 'gbprod/yanky.nvim',        opts = {} },
        { 'numToStr/Comment.nvim',    opts = {} },
        { 'ethanholz/nvim-lastplace', opts = {} },

        {
            'lukas-reineke/indent-blankline.nvim',
            main = 'ibl',
            ---@module 'ibl'
            ---@type ibl.config
            opts = {},
        },
        {
            'kylechui/nvim-surround',
            version = '*',
            event = 'VeryLazy',
            opts = {}
        },
        {
            'goolord/alpha-nvim',
            event = 'VimEnter',
            dependencies = {
                'nvim-tree/nvim-web-devicons'
            },
            opts = function()
                return require('alpha.themes.startify').config
            end
        },
        { 'folke/which-key.nvim',  opts = {} },
        { 'tpope/vim-repeat' },
        { 'windwp/nvim-autopairs', event = 'InsertEnter', opts = {}, },
        { 'mbbill/undotree',       cmd = 'UndotreeToggle' },
        { 'godlygeek/tabular' },
        { 'sindrets/diffview.nvim' },

        { -- rainbow-delimiters.nvim
            'HiPhish/rainbow-delimiters.nvim',
            dependencies = {
                'nvim-treesitter/nvim-treesitter',
            }
        },
    },

    { -- status line
        'nvim-lualine/lualine.nvim',
        event = 'VimEnter',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        opts = {}
    },
    { -- outline
        'hedyhli/outline.nvim',
        lazy = true,
        cmd = { 'Outline', 'OutlineOpen' },
        dependencies = {
            'epheien/outline-treesitter-provider.nvim',
            'epheien/outline-ctags-provider.nvim'
        },
        opts = {
            providers = {
                priority = { 'lsp', 'ctag', 'markdown', 'treesitter', 'ctags', },
            },
        }
    },
    { -- git
        { 'tpope/vim-fugitive' },
        {
            'rbong/vim-flog',
            lazy = true,
            cmd = { 'Flog', 'Flogsplit', 'Floggit' },
            dependencies = {
                'tpope/vim-fugitive',
            },
        },
        { -- gitsigns.nvim
            'lewis6991/gitsigns.nvim',
            opts = {
                on_attach = function(bufnr)
                    local gitsigns = require('gitsigns')

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    map('n', ']c', function()
                        if vim.wo.diff then
                            vim.cmd.normal({ ']c', bang = true })
                        else
                            gitsigns.nav_hunk('next')
                        end
                    end)

                    map('n', '[c', function()
                        if vim.wo.diff then
                            vim.cmd.normal({ '[c', bang = true })
                        else
                            gitsigns.nav_hunk('prev')
                        end
                    end)
                end
            },
        },
    },
    { -- colors
        { 'folke/tokyonight.nvim', name = 'tokyonight', priority = 1000 },
        { 'dracula/vim',           name = 'dracula',    priority = 1000 },
        { 'catppuccin/nvim',       name = 'catppuccin', priority = 1000 },
    },


    ------------------------------------
    {
        "nvimtools/none-ls.nvim",
        enabled = false,
        opts = function(_, opts)
            local nls = require("null-ls")
            opts.sources = opts.sources or {}
            table.insert(opts.sources, nls.builtins.formatting.prettier)
        end,
    },
    {
        "stevearc/conform.nvim",
        enabled = false,
        opts = {
            formatters_by_ft = {
                markdown = { 'prettierd', 'prettier' }
            },
        }
    },
    { -- snippets
        {
            "L3MON4D3/LuaSnip",
            version = "v2.*",
            build = "make install_jsregexp",
            dependencies = {
                "rafamadriz/friendly-snippets",
                "honza/vim-snippets",
            },
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
                require("luasnip.loaders.from_snipmate").lazy_load()
            end
        },
        {
            "SirVer/ultisnips",
            dependencies = {
                { name = "ddvim-snippets", dir = '/home/ddcien/WORK/ddvim-snippets' },
            }
        }
    },
}

local M = {}

function M.get_plugins(opts)
    opts = opts or {}
    if opts.use_native_lsp then
        table.insert(plugins, require("dvim.plugins.lsp"))
        if opts.use_blink_cmp then
            table.insert(plugins, require("dvim.plugins.blink"))
        else
            table.insert(plugins, require("dvim.plugins.cmp"))
        end
    else
        table.insert(plugins, require("dvim.plugins.duggee"))
    end
    table.insert(plugins, require("dvim.plugins.dap"))
    table.insert(plugins, require("dvim.plugins.ai"))
    return plugins
end

return M
