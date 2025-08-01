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

return {
    { 'j-hui/fidget.nvim', opts = {}, },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'j-hui/fidget.nvim',
            'saghen/blink.cmp',
            'nvim-telescope/telescope.nvim',
        },

        ---@class PluginLspOpts
        opts = {
            -- options for vim.diagnostic.config()
            ---@type vim.diagnostic.Opts
            diagnostics = {
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
            },
            inlay_hints = {
                enabled = true,
                exclude = { "vue" },
            },
            codelens = {
                enabled = false,
            },

            capabilities = {
                offsetEncoding = { 'utf-16' },
                workspace = {
                    fileOperations = {
                        didRename = true,
                        willRename = true,
                    },
                },
            },
            format = {
                formatting_options = nil,
                timeout_ms = nil,
            },

            ---@type lspconfigoptions
            servers = {
                clangd = {},
                basedpyright = {},
                ruff = {},
                rust_analyzer = {},
                neocmake = {}, -- 'cmake'
                lua_ls = {},   -- 'lua'
                marksman = {}, -- 'markdown'
                vimls = {},    -- 'vim',
                verible = {},  -- 'verilog'
                dts_lsp = {},  -- 'devicetree
                bashls = {},
                -- looklsp = {},
            },
            -- you can do any additional lsp server setup here
            -- return true if you don't want this server to be setup with lspconfig
            ---@type table<string, fun(server:string, opts:_lspconfig.options):boolean?>
            setup = {
                -- example to setup with typescript.nvim
                -- tsserver = function(_, opts)
                --   require("typescript").setup({ server = opts })
                --   return true
                -- end,
                -- Specify * to use this function as a fallback for any server
                -- ["*"] = function(server, opts) end,
            },
        },

        ---@param opts PluginLspOpts
        config = function(_, opts)
            vim.diagnostic.config(vim.deepcopy(opts.diagnostics))
            config_lsp_mappings()

            for server, config in pairs(opts.servers) do
                config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
                vim.lsp.config(server, config)
                vim.lsp.enable(server)
            end
        end,
    },
    {
        'hasansujon786/nvim-navbuddy',
        dependencies = {
            'neovim/nvim-lspconfig',
            'MunifTanjim/nui.nvim',
            'SmiteshP/nvim-navic',
            'numToStr/Comment.nvim',
            'nvim-telescope/telescope.nvim',
        },
        opts = { lsp = { auto_attach = true } }
    },
}
