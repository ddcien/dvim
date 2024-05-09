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
            close_events = {
                "BufLeave",
                "CursorMoved",
                "InsertEnter",
                "FocusLost",
                "TextChanged"
            },
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

    vim.keymap.set('n', '<C-J>', function()
        vim.diagnostic.goto_next({
            wrap = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                scope = 'cursor',
                close_events = {
                    "BufLeave",
                    "CursorMoved",
                    "InsertEnter",
                    "FocusLost",
                    "TextChanged"
                },
            }
        })
    end)
    vim.keymap.set('n', '<C-k>', function()
        vim.diagnostic.goto_prev({
            wrap = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                scope = 'cursor',
                close_events = {
                    "BufLeave",
                    "CursorMoved",
                    "InsertEnter",
                    "FocusLost",
                    "TextChanged"
                },
            }
        })
    end)



end

return M
