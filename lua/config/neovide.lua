if vim.g.neovide then
    vim.g.neovide_hide_mouse_when_typing = true
    vim.g.neovide_no_idle = true
    vim.g.neovide_confirm_quit = true

    vim.g.neovide_cursor_animation_length = 0.1

    vim.o.mouse = 'nv'

    local function set_ime(args)
        if args.event:match("Enter$") then
            vim.g.neovide_input_ime = true
        else
            vim.g.neovide_input_ime = false
        end
    end


    local ime_input = vim.api.nvim_create_augroup("ime_input", { clear = true })

    vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
        group = ime_input,
        pattern = "*",
        callback = set_ime
    })

    vim.api.nvim_create_autocmd({ "CmdlineEnter", "CmdlineLeave" }, {
        group = ime_input,
        pattern = "[/\\?]",
        callback = set_ime
    })

    vim.keymap.set('', '<A-F11>',
        function()
            vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
        end,
        { noremap = true, silent = true }
    )
end
