return {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    opts = {
        picker = { enabled = true },
        bigfile = { enabled = true },

        -- dashboard = { enabled = true }, -- goolord/alpha-nvim
        -- explorer = { enabled = true },  -- nvim-tree/nvim-tree.lua
        indent = { enabled = true },   -- lukas-reineke/indent-blankline.nvim
        input = { enabled = true },    -- Better vim.ui.input
        -- notifier = { enabled = true }, -- Pretty vim.notify
        quickfile = { enabled = true },
        scope = { enabled = true },
        -- scroll = { enabled = true },
        -- statuscolumn = { enabled = true },
        -- words = { enabled = true },
    },
    keys = {
        { "<c-p>", function() require("snacks").picker.files() end, desc = "Find Files" },
        -- { "<leader><space>", function() Snacks.picker.smart() end,                                   desc = "Smart Find Files" },
        -- { "<leader>fc",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
        -- { "<leader>ff",      function() Snacks.picker.files() end,                                   desc = "Find Files" },
        -- { "<leader>fg",      function() Snacks.picker.git_files() end,                               desc = "Find Git Files" },
        -- { "<leader>fp",      function() Snacks.picker.projects() end,                                desc = "Projects" },
        -- { "<leader>fr",      function() Snacks.picker.recent() end,                                  desc = "Recent" },
    },
}
