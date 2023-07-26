local M = {}

function M.load_default_options()
    local utils = require "dvim.utils"
    local cache_dir = utils.get_cache_dir()
    local undodir = utils.join_paths(cache_dir, "undo")
    local shadafile = utils.join_paths(cache_dir, "dvim.shada")

    if not utils.is_directory(undodir) then
        vim.fn.mkdir(undodir, "p")
    end

    local default_options = {
        inccommand = "nosplit",
        wildmenu = true,
        wildmode = "longest:full,full",
        shiftwidth = 4,
        softtabstop = 4,
        smarttab = true,
        smartindent = true,
        textwidth = 80,
        colorcolumn = "+1",
        foldlevel = 2,
        fileencoding = "utf-8",
        background = "dark",

        ------
        number = true,
        cursorline = true,
        clipboard = "unnamedplus",
        tabstop = 4,
        expandtab = true,
        smartcase = true,
        updatetime = 500, -- 400
        signcolumn = "yes",
        hidden = true,
        completeopt = { "menuone", "noinsert", "noselect" },
        termguicolors = true,
        undofile = true,
        laststatus = 3,
        mouse = "", -- ""
        showmode = false,
        showcmd = false,
        backup = false,
        writebackup = false,
        hlsearch = true,
        ignorecase = false,
        swapfile = false,
        title = true,
        wrap = false,
        scrolloff = 8,
        sidescrolloff = 8,
        ruler = false,

        undodir = undodir,
        shadafile = shadafile,
    }

    vim.opt.spelllang:append("cjk")
    vim.opt.shortmess:append("cI")
    vim.opt.whichwrap:append("<,>,[,],h,l")
    vim.opt.fileencodings:append("gbk,big5")

    for k, v in pairs(default_options) do
        vim.opt[k] = v
    end
end

return M
