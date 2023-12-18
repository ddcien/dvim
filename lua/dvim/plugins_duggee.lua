local core_plugins = {
    {
        name = "duggee",
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
}
return core_plugins
