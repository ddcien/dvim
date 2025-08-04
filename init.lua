if vim.g.vscode then
    return
end

vim.deprecate = function() end

vim.keymap.del('n', 'grn')
vim.keymap.del({ 'n', 'x' }, 'gra')
vim.keymap.del('n', 'grr')
vim.keymap.del('n', 'gri')
vim.keymap.del('n', 'grt')
vim.keymap.del('n', 'gO')
vim.keymap.del({ 'i', 's' }, '<C-S>')


require("config.options")
require("config.neovide")
require("config.lazy")

vim.cmd [[colorscheme tokyonight]]

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>')

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.lds" },
    callback = function(ev)
        vim.api.nvim_set_option_value("filetype", "ld", { buf = ev.buf })
    end
})

vim.api.nvim_create_user_command(
    'Rg',
    function(args)
        if string.len(args.args) == 0 then
            Snacks.picker.grep_word()
        else
            Snacks.picker.grep_word({ search = args.args })
        end
    end,
    { nargs = '?' }
)
