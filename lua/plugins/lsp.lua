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

            local snacks = require("snacks")
            _buf_keymap_set('n', 'gD',
                function() snacks.picker.lsp_declarations({ include_current = true }) end,
                "Goto Declaration")
            _buf_keymap_set('n', 'gd',
                function() snacks.picker.lsp_definitions({ include_current = true }) end,
                "Goto Definition")
            _buf_keymap_set('n', 'gt',
                function() snacks.picker.lsp_type_definitions({ include_current = true }) end,
                "Goto T[y]pe Definition")
            _buf_keymap_set('n', 'gi',
                function() snacks.picker.lsp_implementations({ include_current = true }) end,
                "Goto Implementation")
            _buf_keymap_set('n', 'gr',
                function() snacks.picker.lsp_references({ include_current = true }) end,
                "Find References")

            _buf_keymap_set('n', '<F2>', vim.lsp.buf.rename)
            _buf_keymap_set({ 'n', 'v' }, '<F4>', vim.lsp.buf.code_action)
            _buf_keymap_set({ 'n', 'v' }, 'gf',
                function()
                    vim.lsp.buf.code_action(
                        { apply = true, context = { only = { 'quickfix' }, } })
                end)

            local client = vim.lsp.get_client_by_id(evt.data.client_id)
            if client and client.server_capabilities.documentHighlightProvider then
                local is_in_mark = function()
                    local reference_ns = vim.api.nvim_create_namespace('nvim.lsp.references')
                    local cursor = vim.api.nvim_win_get_cursor(0)
                    cursor[1] = cursor[1] - 1
                    local marks = vim.api.nvim_buf_get_extmarks(0, reference_ns, cursor, { 0, 0 },
                        { limit = 1, details = true })

                    local is_in_range = function(mark)
                        local start_ = mark[2] * 0x10000 + mark[3]
                        local end_ = mark[4].end_row * 0x10000 + mark[4].end_col
                        local cursor_ = cursor[1] * 0x10000 + cursor[2]
                        return start_ <= cursor_ and cursor_ < end_
                    end
                    return #marks > 0 and is_in_range(marks[1])
                end

                vim.api.nvim_create_autocmd('CursorHold', {
                    buffer = evt.buf,
                    callback = function()
                        if is_in_mark() then
                            return
                        end
                        vim.lsp.buf.clear_references()
                        vim.lsp.buf.document_highlight()
                    end
                })
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
