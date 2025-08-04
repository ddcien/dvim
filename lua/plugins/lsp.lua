local function config_lsp_mappings()
    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(evt)
            local function _buf_keymap_set(mode, lhs, rhs, desc)
                vim.keymap.set(mode, lhs, rhs, {
                    noremap = true,
                    silent = true,
                    buffer = evt.buf,
                    desc = desc
                })
            end

            _buf_keymap_set('n', '<C-J>', function() vim.diagnostic.jump({ count = 1, float = true }) end)
            _buf_keymap_set('n', '<C-K>', function() vim.diagnostic.jump({ count = -1, float = true }) end)

            _buf_keymap_set('n', 'gD', Snacks.picker.lsp_declarations, "Goto Declaration")
            _buf_keymap_set('n', 'gd', Snacks.picker.lsp_definitions, "Goto Definition")
            _buf_keymap_set('n', 'gt', Snacks.picker.lsp_type_definitions, "Goto T[y]pe Definition")
            _buf_keymap_set('n', 'gi', Snacks.picker.lsp_implementations, "Goto Implementation")
            _buf_keymap_set('n', 'gr', Snacks.picker.lsp_references, "Find References")

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
            'folke/snacks.nvim'
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
                require('lspconfig')[server].setup(config)
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
        },
        opts = { lsp = { auto_attach = true } }
    },
}
