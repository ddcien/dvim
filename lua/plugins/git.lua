return {
    { 'tpope/vim-fugitive' },
    {
        'rbong/vim-flog',
        lazy = true,
        cmd = { 'Flog', 'Flogsplit' },
        dependencies = {
            'tpope/vim-fugitive',
        },
    },
    {
        'sindrets/diffview.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
    },
    {
        "wintermute-cell/gitignore.nvim",
        cmd = "Gitignore",
        opts = {},
    },
    { -- gitsigns.nvim
        'lewis6991/gitsigns.nvim',
        opts = {
            on_attach = function(buffer)
                local gitsigns = require('gitsigns')

                local function map(mode, l, r, desc)
                    vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
                end

                map('n', ']c', function()
                    if vim.wo.diff then
                        vim.cmd.normal({ ']c', bang = true })
                    else
                        gitsigns.nav_hunk('next')
                    end
                end, "Next Hunk")

                map('n', '[c', function()
                    if vim.wo.diff then
                        vim.cmd.normal({ '[c', bang = true })
                    else
                        gitsigns.nav_hunk('prev')
                    end
                end, "Prev Hunk")
            end
        },
    },
}
