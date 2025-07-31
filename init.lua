if vim.g.vscode then
    return
end

vim.deprecate = function() end

require("dvim.settings").load_default_options()
require("dvim.neovide")
require("dvim.lazy")

vim.cmd [[colorscheme tokyonight]]

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>')

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.lds" },
    callback = function(ev)
        vim.api.nvim_set_option_value("filetype", "ld", { buf = ev.buf })
    end
})
