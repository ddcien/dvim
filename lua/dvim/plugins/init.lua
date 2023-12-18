local core_plugins = {
    -- // unitls
    { "folke/lazy.nvim",             tag = "stable" },
    { "nvim-lua/plenary.nvim",       lazy = true },
    { "nvim-tree/nvim-web-devicons", lazy = true, },

    -- // telescope
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        lazy = true,
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
            vim.api.nvim_create_autocmd("User", {
                pattern = "TelescopePreviewerLoaded",
                callback = function(args)
                    vim.wo.number = true
                end,
            })
        end
    },
    -- // treesitter
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
    { 'mbbill/undotree',   cmd = "UndotreeToggle" },
    { "SirVer/ultisnips", },
    { "honza/vim-snippets" },
    { name = "ddvim-snippets", dir = '/home/ddcien/WORK/ddvim-snippets' },
    { 'numToStr/Comment.nvim',    opts = {} },
    { "folke/which-key.nvim",     opts = {} },
    { 'ethanholz/nvim-lastplace', opts = {} },
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
        "nvim-lualine/lualine.nvim",
        opts = {},
        event = "VimEnter",
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {}
    },
    { "tpope/vim-repeat" },
    { "tpope/vim-fugitive" },
    { "kevinhwang91/nvim-bqf", ft = "qf" },
    { "gbprod/yanky.nvim",     opts = {} },
    { "folke/tokyonight.nvim", name = "tokyonight", lazy = true, priority = 1000 },
    { "dracula/vim",           name = "dracula",    lazy = true, priority = 1000 },
    { "catppuccin/nvim",       name = "catppuccin", lazy = true, priority = 1000 },
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
    {
        'majutsushi/tagbar',
        cmd = 'TagbarToggle',
        config = function()
            vim.g.tagbar_sort = 0
        end
    },
    {
        'iamcco/markdown-preview.nvim',
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
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
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {},
    },
}

return core_plugins
