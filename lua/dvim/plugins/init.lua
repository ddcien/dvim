local core_plugins = {
    -- // unitls
    { "folke/lazy.nvim",             tag = "stable" },
    { "nvim-lua/plenary.nvim",       lazy = true },
    { "nvim-tree/nvim-web-devicons", lazy = true, },

    { -- // telescope
        "nvim-telescope/telescope.nvim",
        event = 'VimEnter',
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            'nvim-telescope/telescope-ui-select.nvim',
            'nvim-tree/nvim-web-devicons',
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build =
                "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
            },
        },
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")
            local builtin = require("telescope.builtin")
            telescope.load_extension("fzf")
            telescope.load_extension("ui-select")
            require('telescope').setup {
                defaults = {
                    dynamic_preview_title = true,
                    mappings = {
                        i = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                        },
                    },
                },
                extensions = {
                    ['fzf'] = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                    ['ui-select'] = {
                        require('telescope.themes').get_dropdown(),
                    },
                },
            }
            vim.keymap.set('n', '<c-p>', builtin.find_files, { noremap = true, silent = true })
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
            vim.api.nvim_create_autocmd("User", {
                pattern = "TelescopePreviewerLoaded",
                callback = function(args)
                    vim.wo.number = true
                end,
            })
        end,
    },
    { -- // treesitter
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
                    enable = true,
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
    { 'HiPhish/rainbow-delimiters.nvim', },
    { 'mbbill/undotree',                 cmd = "UndotreeToggle" },
    -- { "SirVer/ultisnips", },
    { "honza/vim-snippets" },
    { name = "ddvim-snippets",           dir = '/home/ddcien/WORK/ddvim-snippets' },
    { "rafamadriz/friendly-snippets" },
    { 'numToStr/Comment.nvim',           opts = {} },
    { "folke/which-key.nvim",            opts = {} },
    { 'ethanholz/nvim-lastplace',        opts = {} },
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
    { "folke/tokyonight.nvim", name = "tokyonight", priority = 1000 },
    { "dracula/vim",           name = "dracula",    priority = 1000 },
    { "catppuccin/nvim",       name = "catppuccin", priority = 1000 },
    {
        "andymass/vim-matchup",
        init = function()
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
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {},
    },
    {
        'godlygeek/tabular'
    },
    {
        'SirVer/ultisnips',
    },

    {
        'kevinhwang91/nvim-ufo',
        dependencies = { 'kevinhwang91/promise-async', },
        config = function(_, opts)
            vim.o.foldcolumn = '0' -- '0' is not bad
            vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true
            require('ufo').setup({
                provider_selector = function(bufnr, filetype, buftype)
                    return { 'treesitter', 'indent' }
                end
            })
        end,
    }
}

return core_plugins
