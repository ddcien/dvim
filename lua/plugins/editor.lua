return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        opts = {},
    },
    {
        "folke/trouble.nvim",
        cmd = "Trouble",
        opts = {},
    },
    {
        "folke/todo-comments.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        cmd = {
            'TodoLocList',
            'TodoQuickFix',
        },
        opts = {}
    }
}
