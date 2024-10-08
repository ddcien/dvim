local M = {}

function M.load_default_options()
    local utils = require("dvim.utils")
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
        colorcolumn = "+1",
        fileencoding = "utf-8",
        background = "dark",

        ------
        breakindent = true,
        timeoutlen = 300,
        splitright = true,
        splitbelow = true,
        list = true,
        listchars = { tab = '» ', trail = '·', nbsp = '␣', eol = '' },
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
        mouse = "",
        showmode = false,
        showcmd = false,
        backup = false,
        writebackup = false,
        hlsearch = true,
        ignorecase = true,
        swapfile = false,
        title = true,
        wrap = true,
        linebreak = true,
        scrolloff = 8,
        sidescrolloff = 8,
        ruler = false,
        fileencodings = "utf-8,gbk",
        undodir = undodir,
        shadafile = shadafile,
        foldlevel = 2,
    }

    vim.opt.spelllang:append("cjk")
    vim.opt.shortmess:append("cI")
    vim.opt.whichwrap:append("<,>,[,],h,l")

    for k, v in pairs(default_options) do
        vim.opt[k] = v
    end

    vim.g.c_syntax_for_h = 0
end

return M
