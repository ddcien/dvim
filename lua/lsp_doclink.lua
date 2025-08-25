---@diagnostic disable: duplicate-doc-field
local util = require('vim.lsp.util')
local log = require('vim.lsp.log')
local ms = require('vim.lsp.protocol').Methods
local api = vim.api
local M = {}

---@class (private) vim.lsp.document_link.globalstate Global state for document links
---@field enabled boolean Whether document links are enabled for this scope
---@type vim.lsp.document_link.globalstate
local globalstate = {
    enabled = false,
}

---@class (private) vim.lsp.document_link.bufstate: vim.lsp.document_link.globalstate Buffer local state for document links
---@field version? integer
---@field client_links? table<integer, lsp.DocumentLink[]> client_id -> links
---@field applied integer Last version of links applied to this line

---@type table<integer, vim.lsp.document_link.bufstate>
local bufstates = vim.defaulttable(function(_)
    return setmetatable({ applied = 0 }, {
        __index = globalstate,
        __newindex = function(state, key, value)
            if globalstate[key] == value then
                rawset(state, key, nil)
            else
                rawset(state, key, value)
            end
        end,
    })
end)

local namespace = api.nvim_create_namespace('nvim.lsp.document_link')
local augroup = api.nvim_create_augroup('nvim.lsp.document_link', {})

--- |lsp-handler| for the method `textDocument/DocumentLink`
--- Store links for a specific buffer and client
---@param result lsp.DocumentLink[]?
---@param ctx lsp.HandlerContext
---@private
local function on_document_link(err, result, ctx)
    if err then
        log.error('document_link', err)
        return
    end
    local bufnr = assert(ctx.bufnr)
    if
        util.buf_versions[bufnr] ~= ctx.version
        or not result
        or not api.nvim_buf_is_loaded(bufnr)
        or not bufstates[bufnr].enabled
    then
        return
    end

    local client_id = ctx.client_id
    local bufstate = bufstates[bufnr]
    if not (bufstate.client_links and bufstate.version) then
        bufstate.client_links = vim.defaulttable()
        bufstate.version = ctx.version
    end

    bufstate.client_links[client_id] = result
    bufstate.version = ctx.version
    api.nvim__redraw({ buf = bufnr, valid = true, flush = false })
end

--- Refresh document links, only if we have attached clients that support it
---@param bufnr (integer) Buffer handle, or 0 for current
---@param client_id (integer) Client ID, or nil for all
local function refresh(bufnr, client_id)
    local client = assert(vim.lsp.get_client_by_id(client_id))
    if not client:supports_method(ms.textDocument_documentLink, bufnr) then
        return
    end
    client:request(ms.textDocument_documentLink, {
        textDocument = util.make_text_document_params(bufnr),
    }, on_document_link, bufnr)
end

-------------------
--- Clear document links
---@param bufnr (integer) Buffer handle, or 0 for current
---@param client_id (integer) Client ID, or nil for all
local function clear(bufnr, client_id)
    bufnr = vim._resolve_bufnr(bufnr)
    local bufstate = bufstates[bufnr]
    if bufstate then
        bufstate.client_links[client_id] = {}
    end
    api.nvim_buf_clear_namespace(bufnr, namespace, 0, -1)
    api.nvim__redraw({ buf = bufnr, valid = true, flush = false })
end

--- Disable document links for a buffer
---@param bufnr (integer) Buffer handle, or 0 for current
---@param client_id (integer) Client ID, or nil for all
local function _disable(bufnr, client_id)
    bufnr = vim._resolve_bufnr(bufnr)
    clear(bufnr, client_id)
    bufstates[bufnr] = nil
    bufstates[bufnr].enabled = false
end

--- Enable document links for a buffer
---@param bufnr (integer) Buffer handle, or 0 for current
---@param client_id? (integer) Client ID, or nil for all
local function _enable(bufnr, client_id)
    bufnr = vim._resolve_bufnr(bufnr)
    bufstates[bufnr] = nil
    bufstates[bufnr].enabled = true
    refresh(bufnr, client_id)
end

api.nvim_create_autocmd('LspNotify', {
    callback = function(args)
        ---@type integer
        local bufnr = args.buf

        if args.data.method ~= ms.textDocument_didChange
            and args.data.method ~= ms.textDocument_didOpen
        then
            return
        end

        if bufstates[bufnr].enabled then
            local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
            if not client:supports_method(ms.textDocument_documentLink, bufnr) then
                return
            end

            refresh(bufnr, args.data.client_id)
        end
    end,
    group = augroup,
})

api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        ---@type integer
        local bufnr = args.buf
        local client_id = args.data.client_id

        api.nvim_buf_attach(bufnr, false, {
            on_reload = function(_, cb_bufnr)
                clear(cb_bufnr, client_id)
                if bufstates[cb_bufnr] and bufstates[cb_bufnr].enabled then
                    bufstates[cb_bufnr].applied = 0
                    refresh(cb_bufnr, client_id)
                end
            end,
            on_detach = function(_, cb_bufnr)
                _disable(cb_bufnr, client_id)
                bufstates[cb_bufnr] = nil
            end,
        })
    end,
    group = augroup,
})

api.nvim_create_autocmd('LspDetach', {
    callback = function(args)
        ---@type integer
        local bufnr = args.buf
        _disable(bufnr, args.data.client_id)
    end,
    group = augroup,
})


local function get_line_byte_from_position(bufnr, position, position_encoding)
    local col = position.character
    if col > 0 then
        return vim.str_byteindex(
            vim.api.nvim_buf_get_lines(bufnr, position.line, position.line + 1, false)[1]
            , position_encoding, col, false)
    end
    return col
end

api.nvim_set_decoration_provider(namespace, {
    on_win = function(_, _, bufnr, topline, botline)
        ---@type vim.lsp.document_link.bufstate
        local bufstate = rawget(bufstates, bufnr)
        if not bufstate then
            return
        end

        if bufstate.version ~= util.buf_versions[bufnr] then
            return
        end

        if not bufstate.client_links then
            return
        end

        if bufstate.applied == bufstate.version then
            return
        end

        local client_links = assert(bufstate.client_links)

        -- aaaa
        -- api.nvim_buf_clear_namespace(bufnr, namespace, topline, botline)
        api.nvim_buf_clear_namespace(bufnr, namespace, 0, -1)

        for client_id, doc_links in pairs(client_links) do
            for _, link in pairs(doc_links) do
                local client = assert(vim.lsp.get_client_by_id(client_id))
                local start_row = link.range.start.line
                local start_col = get_line_byte_from_position(bufnr, link.range.start, client.offset_encoding)
                local end_row = link.range['end'].line
                local end_col = get_line_byte_from_position(bufnr, link.range['end'], client.offset_encoding)

                -- if lnum >= topline and lnum < botline then
                api.nvim_buf_set_extmark(bufnr, namespace, start_row, start_col, {
                    end_row = end_row,
                    end_col = end_col,
                    hl_group = 'Underlined',
                    ephemeral = false,
                    virt_text = { { vim.uri_to_fname(link.target), 'LspInlayHint' } },
                })
                -- end
                -- local target = link.target
                -- vim.print(lnum, target)
            end
        end


        -- api.nvim_buf_set_extmark(bufnr, namespace, lnum, pos, {
        --     virt_text_pos = 'inline',
        --     ephemeral = false,
        --     virt_text = vt,
        -- })

        -- aaaa
        bufstate.applied = bufstate.version
    end,
})
---------------
--- Query whether inlay hint is enabled in the {filter}ed scope
--- @param filter? vim.lsp.document_link.enable.Filter
--- @return boolean
--- @since 12
function M.is_enabled(filter)
    vim.validate('filter', filter, 'table', true)
    filter = filter or {}
    local bufnr = filter.bufnr

    if bufnr == nil then
        return globalstate.enabled
    end
    return bufstates[vim._resolve_bufnr(bufnr)].enabled
end

--- Optional filters |kwargs|, or `nil` for all.
--- @class vim.lsp.document_link.enable.Filter
--- @inlinedoc
--- Buffer number, or 0 for current buffer, or nil for all.
--- @field bufnr integer?

--- Enables or disables document links for the {filter}ed scope.
---
--- To "toggle", pass the inverse of `is_enabled()`:
---
--- ```lua
--- vim.lsp.document_link.enable(not vim.lsp.document_link.is_enabled())
--- ```
---
--- @param enable (boolean|nil) true/nil to enable, false to disable
--- @param filter vim.lsp.document_link.enable.Filter?
--- @since 12
function M.enable(enable, filter)
    vim.validate('enable', enable, 'boolean', true)
    vim.validate('filter', filter, 'table', true)
    enable = enable == nil or enable
    filter = filter or {}

    if filter.bufnr == nil then
        globalstate.enabled = enable
        for _, bufnr in ipairs(api.nvim_list_bufs()) do
            if api.nvim_buf_is_loaded(bufnr) then
                if enable == false then
                    _disable(bufnr, filter.client_id)
                else
                    _enable(bufnr, filter.client_id)
                end
            else
                bufstates[bufnr] = nil
            end
        end
    else
        if enable == false then
            _disable(filter.bufnr, filter.client_id)
        else
            _enable(filter.bufnr, filter.client_id)
        end
    end
end

--- |lsp-handler| for the method `workspace/inlayHint/refresh`
---@param ctx lsp.HandlerContext
---@private
function M.on_refresh(err, _, ctx)
    if err then
        return vim.NIL
    end
    for _, bufnr in ipairs(vim.lsp.get_buffers_by_client_id(ctx.client_id)) do
        for _, winid in ipairs(api.nvim_list_wins()) do
            if api.nvim_win_get_buf(winid) == bufnr then
                if bufstates[bufnr] and bufstates[bufnr].enabled then
                    bufstates[bufnr].applied = {}
                    refresh(bufnr, ctx.client_id)
                end
            end
        end
    end

    return vim.NIL
end

--- Optional filters |kwargs|:
--- @class vim.lsp.document_link.get.Filter
--- @inlinedoc
--- @field bufnr integer?
--- @field range lsp.Range?

--- @class vim.lsp.document_link.get.ret
--- @inlinedoc
--- @field bufnr integer
--- @field client_id integer
--- @field document_link lsp.InlayHint

--- Get the list of document links, (optionally) restricted by buffer or range.
---
--- Example usage:
---
--- ```lua
--- local hint = vim.lsp.document_link.get({ bufnr = 0 })[1] -- 0 for current buffer
---
--- local client = vim.lsp.get_client_by_id(hint.client_id)
--- local resp = client:request_sync('inlayHint/resolve', hint.document_link, 100, 0)
--- local resolved_hint = assert(resp and resp.result, resp.err)
--- vim.lsp.util.apply_text_edits(resolved_hint.textEdits, 0, client.encoding)
---
--- location = resolved_hint.label[1].location
--- client:request('textDocument/hover', {
---   textDocument = { uri = location.uri },
---   position = location.range.start,
--- })
--- ```
---
--- @param filter vim.lsp.document_link.get.Filter?
--- @return vim.lsp.document_link.get.ret[]
--- @since 12
function M.get(filter)
    vim.validate('filter', filter, 'table', true)
    filter = filter or {}

    local bufnr = filter.bufnr
    if not bufnr then
        --- @type vim.lsp.document_link.get.ret[]
        local links = {}
        --- @param buf integer
        vim.tbl_map(function(buf)
            vim.list_extend(links, M.get(vim.tbl_extend('keep', { bufnr = buf }, filter)))
        end, vim.api.nvim_list_bufs())
        return links
    else
        bufnr = vim._resolve_bufnr(bufnr)
    end

    local bufstate = bufstates[bufnr]
    if not bufstate.client_links then
        return {}
    end

    local clients = vim.lsp.get_clients({
        bufnr = bufnr,
        method = ms.textDocument_inlayHint,
    })
    if #clients == 0 then
        return {}
    end

    local range = filter.range
    if not range then
        range = {
            start = { line = 0, character = 0 },
            ['end'] = { line = api.nvim_buf_line_count(bufnr), character = 0 },
        }
    end

    --- @type vim.lsp.document_link.get.ret[]
    local result = {}
    for _, client in pairs(clients) do
        local lnum_links = bufstate.client_links[client.id]
        if lnum_links then
            for lnum = range.start.line, range['end'].line do
                local links = lnum_links[lnum] or {}
                for _, hint in pairs(links) do
                    local line, char = hint.position.line, hint.position.character
                    if
                        (line > range.start.line or char >= range.start.character)
                        and (line < range['end'].line or char <= range['end'].character)
                    then
                        table.insert(result, {
                            bufnr = bufnr,
                            client_id = client.id,
                            document_link = hint,
                        })
                    end
                end
            end
        end
    end
    return result
end

return M
