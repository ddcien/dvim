local function config_ui()
    vim.diagnostic.config({
        virtual_text = false,
        update_in_insert = false,
        underline = true,
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
    })
end

local function config_lsp_mappings()
    local telescope = require('telescope.builtin')
    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(evt)
            local function _buf_keymap_set(mode, lhs, rhs)
                vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = evt.buf })
            end
            vim.bo[evt.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
            _buf_keymap_set('n', '<C-J>', function() vim.diagnostic.jump({ count = 1, float = true }) end)
            _buf_keymap_set('n', '<C-K>', function() vim.diagnostic.jump({ count = -1, float = true }) end)
            _buf_keymap_set('n', 'K', vim.lsp.buf.hover)
            _buf_keymap_set('n', 'gD', vim.lsp.buf.declaration)
            _buf_keymap_set('n', 'gd', telescope.lsp_definitions)
            _buf_keymap_set('n', 'gt', telescope.lsp_type_definitions)
            _buf_keymap_set('n', 'gi', telescope.lsp_implementations)
            _buf_keymap_set('n', 'gr', function() telescope.lsp_references({ include_current_line = true }) end)
            _buf_keymap_set('n', '<F2>', vim.lsp.buf.rename)
            _buf_keymap_set('i', '<C-K>', vim.lsp.buf.signature_help)
            _buf_keymap_set({ 'n', 'v' }, '<F3>', function() vim.lsp.buf.format { async = true } end)
            _buf_keymap_set({ 'n', 'v' }, '<F4>', vim.lsp.buf.code_action)
            _buf_keymap_set({ 'n', 'v' }, 'gf',
                function()
                    vim.lsp.buf.code_action(
                        { apply = true, context = { only = { 'quickfix' }, } })
                end)

            local client = vim.lsp.get_client_by_id(evt.data.client_id)
            if client and client.server_capabilities.documentHighlightProvider then
                vim.api.nvim_create_autocmd('CursorHold',
                    { buffer = evt.buf, callback = vim.lsp.buf.document_highlight })
                vim.api.nvim_create_autocmd('CursorMoved',
                    { buffer = evt.buf, callback = vim.lsp.buf.clear_references })
            end
        end,
    })
end

local function config_lsp_servers()
    local default_capabilities = {
        offsetEncoding = { 'utf-16' },
        textDocument = {
            foldingRange = {
                lineFoldingOnly = true,
                dynamicRegistration = false,
            },
            completion = {
                completionItem = {
                    commitCharactersSupport = true,
                    deprecatedSupport = true,
                    insertReplaceSupport = true,
                    insertTextModeSupport = {
                        valueSet = { 1, 2 }
                    },
                    labelDetailsSupport = true,
                    preselectSupport = true,
                    resolveSupport = {
                        properties = {
                            'documentation',
                            'detail',
                            'additionalTextEdits',
                            'sortText',
                            'filterText',
                            'insertText',
                            'textEdit',
                            'insertTextFormat',
                            'insertTextMode',
                        }
                    },
                    snippetSupport = true,
                    tagSupport = {
                        valueSet = { 1 }
                    }
                },
                completionList = {
                    itemDefaults = {
                        'commitCharacters',
                        'editRange',
                        'insertTextFormat',
                        'insertTextMode',
                        'data',
                    }
                },
                contextSupport = true,
                dynamicRegistration = false,
                insertTextMode = 1
            }
        }
    }

    local lspconfig = require('lspconfig')

    require('lspconfig.configs').looklsp = {
        default_config = {
            cmd = { 'lookls' },
            single_file_support = true,
            -- filetypes = { 'gitcommit', 'text', 'markdown' },
            root_dir = function(fname)
                return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
            end,
        },
    }

    for _, lsp in ipairs({
        'clangd',        -- 'c', 'cpp'
        'basedpyright',  -- 'python'
        'ruff',          -- 'python'
        'rust_analyzer', -- 'rust'
        'neocmake',      -- 'cmake'
        'lua_ls',        -- 'lua'
        'marksman',      -- 'markdown'
        'vimls',         -- 'vim',
        'bashls',
        'looklsp',
        -- 'harper_ls',     -- 'anguage checker'
        -- 'markdown_oxide',
        -- 'omnisharp',
    }) do
        lspconfig[lsp].setup({ capabilities = default_capabilities, })
    end
end

return {
    { 'j-hui/fidget.nvim', opts = {}, },
    {
        'SmiteshP/nvim-navbuddy',
        dependencies = {
            'neovim/nvim-lspconfig',
            'MunifTanjim/nui.nvim',
            'SmiteshP/nvim-navic',
        },
        opts = { lsp = { auto_attach = true } }
    },
    {
        'kevinhwang91/nvim-ufo',
        dependencies = {
            'kevinhwang91/promise-async'
        },
        opts = {
            fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
                local newVirtText = {}
                local suffix = (' 󰁂 %d '):format(endLnum - lnum)
                local sufWidth = vim.fn.strdisplaywidth(suffix)
                local targetWidth = width - sufWidth
                local curWidth = 0
                for _, chunk in ipairs(virtText) do
                    local chunkText = chunk[1]
                    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    if targetWidth > curWidth + chunkWidth then
                        table.insert(newVirtText, chunk)
                    else
                        chunkText = truncate(chunkText, targetWidth - curWidth)
                        local hlGroup = chunk[2]
                        table.insert(newVirtText, { chunkText, hlGroup })
                        chunkWidth = vim.fn.strdisplaywidth(chunkText)
                        -- str width returned from truncate() may less than 2nd argument, need padding
                        if curWidth + chunkWidth < targetWidth then
                            suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
                        end
                        break
                    end
                    curWidth = curWidth + chunkWidth
                end
                table.insert(newVirtText, { suffix, 'MoreMsg' })
                return newVirtText
            end
        },
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'nvim-telescope/telescope.nvim',
            'j-hui/fidget.nvim',
        },
        config = function()
            config_ui()
            config_lsp_mappings()
            config_lsp_servers()
        end
    }
}
