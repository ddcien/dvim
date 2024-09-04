local function config_ui()
    vim.diagnostic.config({
        virtual_text = false,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        signs = true,
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "if_many",
            scope = 'cursor',
            close_events = {
                "BufLeave",
                "CursorMoved",
                "InsertEnter",
                "FocusLost",
                "TextChanged"
            }
        }
    })
end

local function config_lsp_mappings()
    local telescope = require("telescope.builtin")
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
            _buf_keymap_set('n', 'gr', telescope.lsp_references)
            _buf_keymap_set('n', '<F2>', vim.lsp.buf.rename)
            _buf_keymap_set('i', '<C-K>', vim.lsp.buf.signature_help)
            _buf_keymap_set({ 'n', 'v' }, '<F3>', function() vim.lsp.buf.format { async = true } end)
            _buf_keymap_set({ 'n', 'v' }, '<F4>', vim.lsp.buf.code_action)
            _buf_keymap_set({ 'n', 'v' }, 'gf',
                function() vim.lsp.buf.code_action({ apply = true, context = { only = { "quickfix" }, } }) end)

            local client = vim.lsp.get_client_by_id(evt.data.client_id)
            if client and client.server_capabilities.documentHighlightProvider then
                vim.api.nvim_create_autocmd("CursorHold",
                    { buffer = evt.buf, callback = vim.lsp.buf.document_highlight })
                vim.api.nvim_create_autocmd("CursorMoved",
                    { buffer = evt.buf, callback = vim.lsp.buf.clear_references })
            end
        end,
    })
end

local function config_lsp_servers()
    local default_capabilities = {
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
                            "documentation",
                            "detail",
                            "additionalTextEdits",
                            "sortText",
                            "filterText",
                            "insertText",
                            "textEdit",
                            "insertTextFormat",
                            "insertTextMode",
                        }
                    },
                    snippetSupport = true,
                    tagSupport = {
                        valueSet = { 1 }
                    }
                },
                completionList = {
                    itemDefaults = {
                        "commitCharacters",
                        "editRange",
                        "insertTextFormat",
                        "insertTextMode",
                        "data",
                    }
                },
                contextSupport = true,
                dynamicRegistration = false,
                insertTextMode = 1
            }
        }
    }

    local lspconfig = require('lspconfig')

    for _, lsp in ipairs({
        'basedpyright',
        'cmake',
        'jsonls',
        'vimls',
        'clangd',
        'ruff',
        'jsonls',
        'lua_ls',
        -- 'omnisharp',
        -- 'rust_analyzer'
    }) do
        lspconfig[lsp].setup({ capabilities = default_capabilities, })
    end
end

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "tamago324/nlsp-settings.nvim",
        { "j-hui/fidget.nvim",   opts = {}, },
        { "folke/neodev.nvim",   opts = {} },
        { 'mrcjkb/rustaceanvim', version = '^4', lazy = false, },
        {
            "SmiteshP/nvim-navbuddy",
            dependencies = {
                { "MunifTanjim/nui.nvim", },
                { "SmiteshP/nvim-navic",  opts = {}, },
            },
            opts = { lsp = { auto_attach = true } }
        },
        {
            'kevinhwang91/nvim-ufo',
            dependencies = 'kevinhwang91/promise-async',
            config = function()
                local ufo = require('ufo')
                vim.o.foldcolumn = '0'
                vim.o.foldlevel = 99
                vim.o.foldlevelstart = 99
                vim.o.foldenable = true
                ufo.setup()
                vim.keymap.set('n', 'zR', ufo.openAllFolds)
                vim.keymap.set('n', 'zM', ufo.closeAllFolds)
            end
        },
    },
    config = function()
        config_ui()
        config_lsp_mappings()
        config_lsp_servers()
    end
}
