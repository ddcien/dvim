local ms = require('vim.lsp.protocol').Methods
local util = require('vim.lsp.util')
local log = require('vim.lsp.log')
local api = vim.api



local function lsp_inlay_hint_enable(client, bufnr)
    if not client:supports_method(ms.textDocument_inlayHint, bufnr) then
        return
    end
    vim.lsp.inlay_hint.enable(true, {
        bufnr = bufnr,
        client_id = client.id
    })
end

local function lsp_document_link(client, bufnr)
    if not client:supports_method(ms.textDocument_documentLink, bufnr) then
        return
    end
    require('lsp_doclink').enable(true, {
        bufnr = bufnr,
        client_id = client.id
    })
end

local is_in_mark = function(win, buf, namespace)
    local cursor = api.nvim_win_get_cursor(win)
    cursor[1] = cursor[1] - 1
    local marks = api.nvim_buf_get_extmarks(buf, namespace, cursor, { 0, 0 },
        { limit = 1, details = true })

    local is_in_range = function(mark)
        local start_ = mark[2] * 0x10000 + mark[3]
        local end_ = mark[4].end_row * 0x10000 + mark[4].end_col
        local cursor_ = cursor[1] * 0x10000 + cursor[2]
        return start_ <= cursor_ and cursor_ < end_
    end

    return #marks > 0 and is_in_range(marks[1])
end


local function lsp_document_highlight(client, bufnr)
    if not client:supports_method(ms.textDocument_documentHighlight, bufnr) then
        return
    end

    api.nvim_create_autocmd('CursorHold', {
        group = api.nvim_create_augroup('UserLspConfig', { clear = false }),
        buffer = bufnr,
        callback = function(evt)
            local reference_ns = api.nvim_create_namespace('nvim.lsp.references')
            local win = api.nvim_get_current_win()
            if is_in_mark(win, evt.buf, reference_ns) then
                return
            end
            vim.lsp.buf.clear_references()
            client:request(
                ms.textDocument_documentHighlight,
                util.make_position_params(win, client.offset_encoding),
                nil,
                evt.buf)
        end
    })
end

local function config_lsp_mappings()
    api.nvim_create_autocmd('LspAttach', {
        group = api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(args)
            local bufnr = args.buf
            local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
            lsp_inlay_hint_enable(client, bufnr)
            lsp_document_highlight(client, bufnr)
            -- lsp_document_link(client, bufnr)
        end,
    })
end

return {
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
                basedpyright = {}, -- 'python': pip3 install --user --upgrade basedpyright
                ruff = {},         -- 'python': pip3 install --user --upgrade ruff
                bashls = {},       -- 'bash': npm i -g bash-language-server
                neocmake = {},     -- 'cmake'
                lua_ls = {},       -- 'lua'
                marksman = {},     -- 'markdown'
                dts_lsp = {},      -- 'devicetree':
                rust_analyzer = {},
                vimls = {},        -- 'vim',
                verible = {},      -- 'verilog'
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
            -- vim.diagnostic.config(vim.deepcopy(opts.diagnostics))
            config_lsp_mappings()

            -- for server, config in pairs(opts.servers) do
            --     config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
            -- require('lspconfig')[server].setup(config)
            -- end

            vim.lsp.enable({
                'basedpyright', 'ruff', -- 'python': pip3 install --user --upgrade basedpyright ruff
                'bashls',               -- 'bash': npm i -g bash-language-server
                'clangd',               -- 'c/c++': clangd
                'marksman',             -- 'markdown'
                'dts_lsp',              -- 'devicetree'
                'lua_ls',               -- 'lua'
                'neocmake',             -- 'cmake'
                'rust_analyzer',        -- 'rust'
                'vimls',                -- 'vim'
                'verible',              -- 'verilog'
                -- 'lookls',
            })
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
    { 'j-hui/fidget.nvim', opts = {}, },
}
