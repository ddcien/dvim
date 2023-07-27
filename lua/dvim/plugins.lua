local lsp_config = require("dvim.configs.lsp").setup
local cmp_config = require("dvim.configs.nvim_cmp").setup
local icons = require("dvim.icons")

local core_plugins = {
    { "folke/lazy.nvim",   tag = "stable" },
    { "folke/neodev.nvim", opts = {} },
    {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.black,
                },
            })
        end
    },
    {
        "j-hui/fidget.nvim",
        tag = "legacy",
        event = "LspAttach",
        opts = {},
    },
    {
        "p00f/clangd_extensions.nvim",
        lazy = true,
        dependencies = {
            "neovim/nvim-lspconfig",
        },
    },
    {
        'simrat39/rust-tools.nvim',
        lazy = true,
        dependencies = {
            "neovim/nvim-lspconfig",
        },
    },
    {
        'simrat39/symbols-outline.nvim',
        dependencies = {
            "neovim/nvim-lspconfig",
        },
        opts = {},
        cmd = {
            "SymbolsOutline",
        }
    },
    {
        'tamago324/nlsp-settings.nvim',
        opts = {
            config_home = vim.fn.stdpath('config') .. '/nlsp-settings',
            local_settings_dir = ".nlsp-settings",
            local_settings_root_markers_fallback = { '.git' },
            append_default_schemas = true,
            loader = 'json'
        }
    },
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
        "folke/trouble.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons"
        },
        opts = {},
        cmd = {
            "TroubleToggle"
        }
    },
    {
        "neovim/nvim-lspconfig",
        config = lsp_config,
        dependencies = {
            "hrsh7th/nvim-cmp",
            "nvim-telescope/telescope.nvim",
        },
    },
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
        "nvim-lua/plenary.nvim",
        cmd = {
            "PlenaryBustedFile",
            "PlenaryBustedDirectory"
        },
        lazy = true
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build =
        "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        lazy = true,
    },
    {
        "hrsh7th/nvim-cmp",
        config = cmp_config,
        dependencies = {
            "cmp-nvim-lsp",
            "cmp-buffer",
            "cmp-path",
            "cmp_luasnip",
            "onsails/lspkind.nvim",
        },
        event = { "InsertEnter", "CmdlineEnter" },
        lazy = true,
    },
    { "hrsh7th/cmp-nvim-lsp",                lazy = true },
    { "hrsh7th/cmp-buffer",                  lazy = true },
    { "hrsh7th/cmp-path",                    lazy = true },
    { "saadparwaiz1/cmp_luasnip",            lazy = true },

    { "hrsh7th/cmp-calc", },
    { "octaltree/cmp-look" },
    { 'quangnguyen30192/cmp-nvim-ultisnips', },
    { "SirVer/ultisnips", },
    { "honza/vim-snippets" },
    { "onsails/lspkind.nvim" },
    -------------------
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp"
    },
    {
        "rafamadriz/friendly-snippets",
    },
    {
        'mbbill/undotree',
        cmd = "UndotreeToggle"
    },
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup()
            local cmp = require("cmp")
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            cmp.event:off("confirm_done", cmp_autopairs.on_confirm_done)
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done)
        end,
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/nvim-cmp",
            "nvim-treesitter/nvim-treesitter",
        },
    },

    -- Treesitter
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
        event = "User FileOpened",
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
        "nvim-tree/nvim-web-devicons", lazy = true,
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
    {
        "folke/which-key.nvim",
        opts = {},
    },
    {
        'numToStr/Comment.nvim',
        opts = {}
    },
    {
        'ethanholz/nvim-lastplace',
        opts = {}
    },
    {
        "andymass/vim-matchup",
        setup = function()
            vim.g.matchup_matchparen_offscreen = { method = "popup" }
        end,
    },
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

    { "tpope/vim-repeat" },
    { "tpope/vim-fugitive" },
    { "kevinhwang91/nvim-bqf", ft = "qf" },
    { "folke/tokyonight.nvim", name = "tokyonight", priority = 1000 },
    { "dracula/vim",           name = "dracula",    priority = 1000 },
    { "catppuccin/nvim",       name = "catppuccin", priority = 1000 },

    { "gbprod/yanky.nvim",     opts = {} },
}

return core_plugins
