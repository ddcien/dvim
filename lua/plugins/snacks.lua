return {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    opts = {
        bigfile = {},
        picker = {},
        input = {},
    },
    keys = {
        { "<c-p>", function() Snacks.picker.files() end, desc = "Find Files" },
        -- { "<leader><space>", function() Snacks.picker.smart() end,                                   desc = "Smart Find Files" },
        -- { "<leader>fc",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
        -- { "<leader>ff",      function() Snacks.picker.files() end,                                   desc = "Find Files" },
        -- { "<leader>fg",      function() Snacks.picker.git_files() end,                               desc = "Find Git Files" },
        -- { "<leader>fp",      function() Snacks.picker.projects() end,                                desc = "Projects" },
        -- { "<leader>fr",      function() Snacks.picker.recent() end,                                  desc = "Recent" },
    },

}
