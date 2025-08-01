if vim.fn.has("nvim-0.9.0") == 0 then
    vim.api.nvim_echo({
        { "Requires Neovim >= 0.9.0\n", "ErrorMsg" },
        { "Press any key to exit",      "MoreMsg" },
    }, true, {})
    vim.fn.getchar()
    vim.cmd([[quit]])
    return {}
end

-- require("dvim.config").init()

return {
    { "folke/lazy.nvim",             version = "*" },
    { "nvim-tree/nvim-web-devicons", opts = {} },
    { "nvim-lua/plenary.nvim",       lazy = true },

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
    {
        'rmagatti/auto-session',
        lazy = false,
        ---enables autocomplete for opts
        ---@module "auto-session"
        ---@type AutoSession.Config
        opts = {
            suppressed_dirs = {
                '~/',
                '~/Projects',
                '~/Downloads',
                '/',
                '/tmp/*'
            },
            bypass_save_filetypes = {
                "dashboard",
                "alpha",
                "neo-tree",
                "NvimTree",
                "lazy",
                "mason",
                "startify",
                "checkhealth",
                "qf",
            },
            auto_restore = false,
            auto_restore_last_session = false,
            cwd_change_handling = false,
        }
    },
    {
        'Civitasv/cmake-tools.nvim',
        lazy = true,
        cmd = { 'CMakeGenerate', 'CMakeBuild', 'CMakeSelectCwd' },
        opts = {
            cmake_dap_configuration = {
                name = "cpp",
                type = "lldb",
                request = "launch",
                stopOnEntry = true,
                runInTerminal = true,
                console = "integratedTerminal",
            },
            cmake_kits_path = "~/.local/share/CMakeTools/cmake-tools-kits.json",
            cmake_use_scratch_buffer = true
        }
    },

    {
        'lukas-reineke/indent-blankline.nvim',
        main = 'ibl',
        ---@module 'ibl'
        ---@type ibl.config
        opts = {
            exclude = {
                filetypes = { "dashboard", "alpha", "neo-tree", "NvimTree", "lazy", "mason", "startify" },
            },
        },
    },
    { -- markdown
        {
            'iamcco/markdown-preview.nvim',
            cmd = { 'MarkdownPreview' },
            ft = { "markdown", "codecompanion" },
            build = function() vim.fn['mkdp#util#install']() end,
            init = function()
                vim.g.mkdp_filetypes = { 'markdown' }
                vim.g.mkdp_preview_options = {
                    disable_filename = true
                }
            end,
        },
        {
            'MeanderingProgrammer/render-markdown.nvim',
            dependencies = {
                'nvim-treesitter/nvim-treesitter',
                'nvim-tree/nvim-web-devicons'
            },
            opts = {},
            ft = { 'markdown', }
        },
    },

    { -- misc
        { 'kevinhwang91/nvim-bqf',    ft = { 'qf' } },
        { 'gbprod/yanky.nvim',        opts = {} },
        { 'numToStr/Comment.nvim',    opts = {} },
        { 'ethanholz/nvim-lastplace', opts = {} },
        {
            'kylechui/nvim-surround',
            version = '*',
            event = 'VeryLazy',
            opts = {}
        },
        { 'tpope/vim-repeat' },
        { 'mbbill/undotree',       cmd = 'UndotreeToggle' },
        { 'godlygeek/tabular' },
        { 'sindrets/diffview.nvim' },
        { "preservim/tagbar" },
        { "ARM9/arm-syntax-vim" },
        {
            "stevearc/conform.nvim",
            keys = {
                { "<leader>f", function() require("conform").format({ async = true }) end, mode = "",          desc = "Format buffer", },
                { "<F3>",      function() require('conform').format({ async = true }) end, mode = { 'n', 'v' } },
            },
            opts = {
                formatters_by_ft = {
                    lua        = { "stylua" },
                    python     = { "isort", "black" },
                    javascript = { "prettierd", "prettier", stop_after_first = true },
                    sh         = { "shfmt", },
                    markdown   = { "prettierd", },
                },
                default_format_opts = {
                    lsp_format = "fallback",
                },
                -- format_on_save = { timeout_ms = 500 },
                -- formatters = {
                --     shfmt = {
                --         prepend_args = { "-i", "2" },
                --     },
                -- },
            },
            init = function()
                vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
            end,
        },
    },
    {'kevinhwang91/nvim-ufo', dependencies = 'kevinhwang91/promise-async'}
}
