local icons = require("dvim.icons")

local M = {}

function M.setup_ui()
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
            source = "always",
            scope = 'cursor',
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        }
    })

    local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
    vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or "rounded"
        return orig_util_open_floating_preview(contents, syntax, opts, ...)
    end
end

function M.setup()
    local signs = {
        Error = icons.diagnostics.Error,
        Warn = icons.diagnostics.Warning,
        Hint = icons.diagnostics.Hint,
        Info = icons.diagnostics.Information
    }
    for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end

    M.setup_ui()

    vim.keymap.set('n', '<C-J>', vim.diagnostic.goto_next)
    vim.keymap.set('n', '<C-K>', vim.diagnostic.goto_prev)

    local telescope = require("telescope.builtin")
    local navic = require("nvim-navic")

    vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(evt)
            vim.bo[evt.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
            local opts = { noremap = true, silent = true, buffer = evt.buf }
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
            vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
            vim.keymap.set('n', 'gd', telescope.lsp_definitions, opts)
            vim.keymap.set('n', 'gt', telescope.lsp_type_definitions, opts)
            vim.keymap.set('n', 'gi', telescope.lsp_implementations, opts)
            vim.keymap.set('n', 'gr', telescope.lsp_references, opts)
            vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
            vim.keymap.set('i', '<C-K>', vim.lsp.buf.signature_help, opts)
            vim.keymap.set({ 'n', 'v' }, '<F3>', function() vim.lsp.buf.format { async = true } end, opts)
            vim.keymap.set({ 'n', 'v' }, '<F4>', vim.lsp.buf.code_action, opts)
            vim.keymap.set({ 'n', 'v' }, 'gf', function()
                local x = vim.lsp.buf.code_action({ apply = true, context = { only = { "quickfix" } } })
                print(vim.inspect(x))
                local d = vim.diagnostic.get(evt.buf, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
                print(vim.inspect(d))
            end, opts)

            local client = vim.lsp.get_client_by_id(evt.data.client_id)
            if client then
                if client.server_capabilities.documentHighlightProvider then
                    vim.api.nvim_create_autocmd("CursorHold",
                        { buffer = evt.buf, callback = vim.lsp.buf.document_highlight })
                    vim.api.nvim_create_autocmd("CursorMoved",
                        { buffer = evt.buf, callback = vim.lsp.buf.clear_references })
                end
                if client.server_capabilities.documentSymbolProvider then
                    navic.attach(client, evt.buf)
                end
            end
        end,
    })

    local lspconfig = require('lspconfig')
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    for _, lsp in ipairs({
        'pyright',
        'cmake',
        'jsonls',
        'vimls',
        'clangd',
        'ruff_lsp',
    }) do
        lspconfig[lsp].setup({ capabilities = capabilities, })
    end


    lspconfig["lua_ls"].setup({
        capabilities = capabilities,
        cmd = {
            "/work/ddcien/lua-language-server/bin/lua-language-server"
        },
        settings = {
            Lua = {
                diagnostics = {
                    globals = {
                        "vim",
                    },
                },
                telemetry = {
                    enable = false
                }
            }
        },
    })
end

return M
