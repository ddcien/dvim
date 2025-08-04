return {
    {                    -- treesitter
        'nvim-treesitter/nvim-treesitter',
        version = false, -- last release is way too old and doesn't work on Windows
        build = ':TSUpdate',
        event = { 'VeryLazy' },
        lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
        cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },

        opts = {
            sync_install = false,
            auto_install = false,
            highlight = { enable = true },
            indent = { enable = true },
            ensure_installed = {
                'bash', 'c', 'cpp', 'cmake', 'comment', 'devicetree', 'diff',
                'dockerfile', 'gitcommit', 'gitignore', 'json', 'jsonc',
                'json', 'jsonc', 'lua', 'make', 'markdown', 'markdown_inline',
                'python', 'query', 'rust', 'verilog', 'vimdoc', 'vim', 'yaml',
                'gitcommit', 'regex'
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
        },
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
    {
        'nvim-treesitter/nvim-treesitter-context',
        event = "VeryLazy",
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        opts = {
            multiline_threshold = 1,
        },
    },
}
