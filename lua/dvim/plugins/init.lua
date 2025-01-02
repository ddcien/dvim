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
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "VeryLazy" },
        cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
        opts = function()
            return {
                sync_install = false,
                auto_install = false,
                ensure_installed = {
                    "bash", "c", "cpp", "cmake", "comment", "devicetree", "diff",
                    "dockerfile", "gitcommit", "gitignore", "json", "jsonc",
                    "json", "jsonc", "lua", "make", "markdown", "markdown_inline",
                    "python", "query", "rust", "verilog", "vimdoc", "vim", "yaml",
                },
                highlight = { enable = true },
                indent = { enable = true },
                matchup = {
                    enable = false,
                    disable = { "c", "cpp" },
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<C-space>",
                        node_incremental = "<C-space>",
                        scope_incremental = false,
                        node_decremental = "<bs>",
                    },
                },
            }
        end,
        config = function(_, opts)
            if type(opts.ensure_installed) == "table" then
                local added = {}
                opts.ensure_installed = vim.tbl_filter(function(lang)
                    if added[lang] then
                        return false
                    end
                    added[lang] = true
                    return true
                end, opts.ensure_installed)
            end
            require("nvim-treesitter.configs").setup(opts)
        end,
    },
    { -- rainbow-delimiters.nvim
        'HiPhish/rainbow-delimiters.nvim',
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        }
    },
    { -- nvim-tree.lua
        "nvim-tree/nvim-tree.lua",
        config = function()
            require("nvim-tree").setup({
                on_attach = function(bufnr)
                    require('nvim-tree.api').config.mappings.default_on_attach(bufnr)
                    vim.keymap.del('n', '<c-e>', { buffer = bufnr })
                end
            })
            vim.keymap.set('n', '<c-e>', "<cmd>NvimTreeToggle<cr>", { noremap = true, silent = true })
        end
    },
    { -- gitsigns.nvim
        "lewis6991/gitsigns.nvim",
        opts = {
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                map('n', ']c',
                    function()
                        if vim.wo.diff then return ']c' end
                        vim.schedule(function() gs.next_hunk() end)
                        return '<Ignore>'
                    end,
                    { expr = true })

                map('n', '[c',
                    function()
                        if vim.wo.diff then return '[c' end
                        vim.schedule(function() gs.prev_hunk() end)
                        return '<Ignore>'
                    end,
                    { expr = true })

                map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
            end

        },
    },
    { -- colors
        { "folke/tokyonight.nvim", name = "tokyonight", priority = 1000 },
        { "dracula/vim",           name = "dracula",    priority = 1000 },
        { "catppuccin/nvim",       name = "catppuccin", priority = 1000 },
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
    { -- markdown
        {
            'iamcco/markdown-preview.nvim',
            cmd = { "MarkdownPreview" },
            ft = { "markdown" },
            build = function() vim.fn["mkdp#util#install"]() end,
            init = function()
                vim.g.mkdp_filetypes = { "markdown" }
                vim.g.mkdp_preview_options = {
                    disable_filename = true
                }
            end,
        },
        {
            "HakonHarnes/img-clip.nvim",
            event = "VeryLazy",
            ft = { "markdown" },
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
    },
    { -- misc
        { "tpope/vim-repeat" },
        {
            "lukas-reineke/indent-blankline.nvim",
            main = "ibl",
            opts = {}
        },
        {
            "NeogitOrg/neogit",
            dependencies = {
                "nvim-lua/plenary.nvim",
                "sindrets/diffview.nvim",
                "nvim-telescope/telescope.nvim",
            },
            config = true
        },
        { "tpope/vim-fugitive" },
        { "kevinhwang91/nvim-bqf",    ft = "qf" },
        { "gbprod/yanky.nvim",        opts = {} },
        { 'numToStr/Comment.nvim',    opts = {} },
        { "folke/which-key.nvim",     opts = {} },
        { 'ethanholz/nvim-lastplace', opts = {} },
        {
            "kylechui/nvim-surround",
            version = "*",
            event = "VeryLazy",
            opts = {}
        },
        {
            'goolord/alpha-nvim',
            event = "VimEnter",
            dependencies = { 'nvim-tree/nvim-web-devicons' },
            opts = function()
                return require('alpha.themes.startify').config
            end
        },
        {
            'majutsushi/tagbar',
            cmd = 'TagbarToggle',
            config = function()
                vim.g.tagbar_sort = 0
            end
        },
        { "windwp/nvim-autopairs", event = "InsertEnter", opts = {}, },
        { 'godlygeek/tabular' },
        { 'mbbill/undotree',       cmd = "UndotreeToggle" },
        { 'sindrets/diffview.nvim' },

        { "windwp/nvim-autopairs", event = "InsertEnter", opts = {}, },
        { 'godlygeek/tabular' },
        { 'mbbill/undotree',       cmd = "UndotreeToggle" },
        { 'sindrets/diffview.nvim' },
    },
    { -- status line
        "nvim-lualine/lualine.nvim",
        event = "VimEnter",
        opts = {
            sections = {
                lualine_x = {
                    function()
                        local status, serverstatus = require("neocodeium").get_status()

                        -- Tables to map serverstatus and status to corresponding symbols
                        local server_status_symbols = {
                            [0] = "󰣺 ", -- Connected
                            [1] = "󰣻 ", -- Connection Error
                            [2] = "󰣽 ", -- Disconnected
                        }

                        local status_symbols = {
                            [0] = "󰚩 ", -- Enabled
                            [1] = "󱚧 ", -- Disabled Globally
                            [2] = "󱙻 ", -- Disabled for Buffer (catch-all)
                            [3] = "󱚢 ", -- Disabled for Buffer filetype
                            [5] = "󱚠 ", -- Disabled for Buffer encoding
                        }

                        -- Handle serverstatus and status fallback (safeguard against any unexpected value)
                        local luacodeium = server_status_symbols[serverstatus] or "󰣼 "
                        luacodeium = luacodeium .. (status_symbols[status] or "󱚧 ")

                        return luacodeium
                    end,
                    'encoding', 'fileformat', 'filetype' }
            }
        },
    },

    {
        "hedyhli/outline.nvim",
        opts = {
            keymaps = {
                close = {}
            }
        },
    },
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
