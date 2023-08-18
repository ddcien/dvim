local icons = require("dvim.icons")

local core_plugins = {
    { "folke/lazy.nvim",             tag = "stable" },
    { "nvim-lua/plenary.nvim",       lazy = true },
    { "nvim-tree/nvim-web-devicons", lazy = true, },

    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "telescope-fzf-native.nvim"
        },
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")
            local builtin = require("telescope.builtin")

            telescope.setup({
                defaults = require("telescope.themes").get_dropdown({
                    dynamic_preview_title = true,
                    mappings = {
                        i = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                        },
                    },
                }),
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                },
            })

            telescope.load_extension("fzf")

            vim.api.nvim_create_user_command(
                "Rg",
                function(args)
                    if string.len(args.args) == 0 then
                        builtin.grep_string()
                    else
                        builtin.grep_string({ search = args.args })
                    end
                end,
                { nargs = "?" }
            )
            vim.keymap.set('n', '<c-p>', builtin.find_files, { noremap = true, silent = true })
        end
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build =
        "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        lazy = true,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = {
                    "bash",
                    "c",
                    "cpp",
                    "cmake",
                    "comment",
                    "devicetree",
                    "diff",
                    "dockerfile",
                    "gitcommit",
                    "gitignore",
                    "json",
                    "lua",
                    "make",
                    "markdown",
                    "python",
                    "rust",
                    "verilog",
                    "vim",
                    "yaml"
                },
                ignore_install = { "comment" },
                sync_install = false,
                auto_install = false,
                matchup = {
                    enable = true,
                },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = {
                    enable = true,
                    disable = { "yaml", "python" }
                },
                playground = {
                    enable = true,
                }
            })
        end,
        cmd = {
            "TSInstall",
            "TSUninstall",
            "TSUpdate",
            "TSUpdateSync",
            "TSInstallInfo",
            "TSInstallSync",
            "TSInstallFromGrammar",
        },
    },
















    { "SirVer/ultisnips", },
    { "honza/vim-snippets" },
    { "L3MON4D3/LuaSnip",             version = "2.*", build = "make install_jsregexp" },
    { "rafamadriz/friendly-snippets", },
    {
        "windwp/nvim-autopairs",
        opts = {},
        event = "InsertEnter",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
    },

    {
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
    { 'mbbill/undotree',          cmd = "UndotreeToggle" },
    {
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
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "SmiteshP/nvim-navic",
        },
        opts = {
            sections = {
                lualine_x = {
                    {
                        'navic',
                        color_correction = "dynamic"
                    }, 'encoding', 'fileformat', 'filetype' },
            }
        },
        event = "VimEnter",
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            use_treesitter = true,
            show_current_context = true,
            show_current_context_start = true,
            show_trailing_blankline_indent = false,
            show_first_indent_level = true,
            char = icons.ui.LineLeft,
            context_char = icons.ui.LineLeft,
            buftype_exclude = { "terminal", "nofile" },
            filetype_exclude = {
                "help",
                "startify",
                "dashboard",
                "lazy",
                "neogitstatus",
                "NvimTree",
                "Trouble",
                "text",
            }
        }
    },
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
        config = function()
            require("alpha").setup(require('alpha.themes.startify').config)
        end
    },
    {
        "andymass/vim-matchup",
        setup = function()
            vim.g.matchup_matchparen_offscreen = { method = "popup" }
        end,
    },
    { "tpope/vim-repeat" },
    { "tpope/vim-fugitive" },
    { "kevinhwang91/nvim-bqf", ft = "qf" },
    { "folke/tokyonight.nvim", name = "tokyonight", lazy = true, priority = 1000 },
    { "dracula/vim",           name = "dracula",    lazy = true, priority = 1000 },
    { "catppuccin/nvim",       name = "catppuccin", lazy = true, priority = 1000 },
    { "gbprod/yanky.nvim",     opts = {} },

    ---------------------------
    {
        name = "duggee",
        dev = true,
        dir = '/home/ddcien/ddcien/duggee2/plugin_lua',
    },
    {
        name = "duggdee",
        dev = true,
        dir = '/home/ddcien/ddcien/duggee2/vim-plugin',
        config = function()
            local opts = { noremap = true, silent = true, }
            vim.keymap.set('n', 'K', "<plug>(duggee_hover)", opts)
            vim.keymap.set('n', 'gD', "<plug>(duggee_declaration)", opts)
            vim.keymap.set('n', 'gd', "<plug>(duggee_definition)", opts)
            vim.keymap.set('n', 'gt', "<plug>(duggee_type_definition)", opts)
            vim.keymap.set('n', 'gi', "<plug>(duggee_implementation)", opts)
            vim.keymap.set('n', 'gr', "<plug>(duggee_references)", opts)
            vim.keymap.set('n', '<F2>', "<plug>(duggee_rename)", opts)
            vim.keymap.set({ 'n', 'v' }, 'gf', "<plug>(duggee_quickfix)", opts)
            vim.keymap.set({ 'n', 'v' }, '<F3>', "<plug>(duggee_format)", opts)
            vim.keymap.set({ 'n', 'v' }, '<F4>', "<plug>(duggee_action)", opts)
            vim.keymap.set('n', '<c-j>', "<plug>(duggee_next_diag)", opts)
            vim.keymap.set('n', '<c-k>', "<plug>(duggee_prev_diag)", opts)
            -- check 'i'
            vim.keymap.set('i', '<c-k>', "<plug>(duggee_signature_help)", opts)
        end
    },
    { 'majutsushi/tagbar', cmd = 'TagbarToggle' },
    {
        'simrat39/symbols-outline.nvim',
        opts = {},
        cmd = {
            "SymbolsOutline",
        }
    },
    {
        'iamcco/markdown-preview.nvim'
    }
}

return core_plugins
