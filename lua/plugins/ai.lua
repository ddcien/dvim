return {
    {
        -- enabled = false,
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        build = ":Copilot auth",
        event = "BufReadPost",
        opts = {
            panel = {
                auto_refresh = true,
            },
            suggestion = {
                enabled = true,
                auto_trigger = true,
                -- hide_during_completion = vim.g.ai_cmp,
                -- keymap = {
                --     accept = false, -- handled by nvim-cmp / blink.cmp
                --     next = "<M-]>",
                --     prev = "<M-[>",
                -- },
            },
            -- filetypes = {
            --     markdown = true,
            --     help = true,
            -- },
        },
    },
    {
        enabled = false,
        "monkoose/neocodeium",
        event = "VeryLazy",
        config = function()
            local neocodeium = require("neocodeium")
            neocodeium.setup({
                manual = false
            })
            vim.keymap.set("i", "<A-f>", neocodeium.accept)
            vim.keymap.set("i", "<A-w>", neocodeium.accept_word)
            vim.keymap.set("i", "<A-a>", neocodeium.accept_line)
            vim.keymap.set("i", "<A-e>", neocodeium.cycle_or_complete)
            vim.keymap.set("i", "<A-r>", function() neocodeium.cycle_or_complete(-1) end)
            vim.keymap.set("i", "<A-c>", neocodeium.clear)
        end
    }
}
