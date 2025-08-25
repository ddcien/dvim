vim.deprecate = function() end

if vim.g.vscode then
    return
end


_G.dd = function(...)
    Snacks.debug.inspect(...)
end
_G.bt = function()
    Snacks.debug.backtrace()
end
vim.print = _G.dd


do
    vim.keymap.del('n', 'grn')
    vim.keymap.del({ 'n', 'x' }, 'gra')

    vim.keymap.del('n', 'grr')
    vim.keymap.del('n', 'gri')
    vim.keymap.del('n', 'grt')
    vim.keymap.del('n', 'gO')

    -- vim.keymap.del('x', 'an')
    -- vim.keymap.del('x', 'in')
    -- vim.keymap.del({ 'i', 's' }, '<C-S>')

    vim.keymap.set('n', 'gd', function() Snacks.picker.lsp_definitions({ include_current = true }) end,
        { desc = 'vim.lsp.buf.definition()' })
    vim.keymap.set('n', 'gD', function() Snacks.picker.lsp_declarations({ include_current = true }) end,
        { desc = 'vim.lsp.buf.declaration()' })
    vim.keymap.set('n', 'gr', function() Snacks.picker.lsp_references({ include_current = true }) end,
        { desc = 'vim.lsp.buf.references()' })
    vim.keymap.set('n', 'gi', function() Snacks.picker.lsp_implementations({ include_current = true }) end,
        { desc = 'vim.lsp.buf.implementation()' })
    vim.keymap.set('n', 'gt', function() Snacks.picker.lsp_type_definitions({ include_current = true }) end,
        { desc = 'vim.lsp.buf.type_definition()' })
    vim.keymap.set('n', 'gO', function() Snacks.picker.lsp_symbols() end, { desc = 'vim.lsp.buf.document_symbol()' })
    vim.keymap.set({ 'n', 'x' }, 'gf',
        function() vim.lsp.buf.code_action({ apply = true, context = { only = { 'quickfix', } } }) end,
        { desc = 'vim.lsp.buf.code_action()' })

    vim.keymap.set('n', '<F2>', function() vim.lsp.buf.rename() end, { desc = 'vim.lsp.buf.rename()' })
    vim.keymap.set({ 'n', 'x' }, '<F4>', function() vim.lsp.buf.code_action() end, { desc = 'vim.lsp.buf.code_action()' })

    -- _buf_keymap_set({ 'n', 'v' }, 'gf', function() vim.lsp.buf.code_action({ apply = true,  }) end)
    -- vim.keymap.set({ 'n', 'x' }, 'gra', function() vim.lsp.buf.code_action() end, { desc = 'vim.lsp.buf.code_action()' })
end

do
    vim.keymap.del('n', ']d')
    vim.keymap.del('n', '[d')
    vim.keymap.del('n', ']D')
    vim.keymap.del('n', '[D')
    vim.keymap.del('n', '<C-W>d')
    vim.keymap.del('n', '<C-W><C-D>')


    vim.keymap.set('n', '<C-J>', function() vim.diagnostic.jump({ count = vim.v.count1, float = true }) end,
        { desc = 'Jump to the next diagnostic in the current buffer' })
    vim.keymap.set('n', '<C-K>', function() vim.diagnostic.jump({ count = -vim.v.count1, float = true }) end,
        { desc = 'Jump to the previous diagnostic in the current buffer' })

    vim.diagnostic.config(
        {
            underline = true,
            update_in_insert = false,
            virtual_text = false,
            severity_sort = true,
            signs = true,
            float = {
                focusable = false,
                style = 'minimal',
                border = 'rounded',
                source = 'if_many',
                scope = 'cursor',
                close_events = {
                    'BufLeave',
                    'CursorMoved',
                    'InsertEnter',
                    'FocusLost',
                    'TextChanged'
                }
            }
        }

    )
end


do
    vim.keymap.del({ 'n', 'x' }, 'gc')
    vim.keymap.del({ 'n' }, 'gcc')
    vim.keymap.del({ 'o' }, 'gc')
end

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
