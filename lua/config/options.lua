local opt = vim.opt

opt.inccommand = "nosplit"         -- preview incremental substitute
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.shiftwidth = 4                 -- Size of an indent
opt.softtabstop = 4                -- default is 0,
opt.smartindent = true             -- default is off, Insert indents automatically
opt.colorcolumn = "+1"
opt.fileencoding = "utf-8"

opt.breakindent = true --
opt.timeoutlen = 300
opt.splitright = true  -- Put new windows right of current
opt.splitbelow = true  -- Put new windows below current
opt.list = true        -- Show some invisible characters (tabs...
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣', eol = '' }
------
opt.number = true                                       -- Print line number
opt.cursorline = true                                   -- Enable highlighting of the current line
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
opt.tabstop = 4                                         -- Number of spaces tabs count for
opt.expandtab = true                                    -- Use spaces instead of tabs
opt.smartcase = true                                    -- Don't ignore case with capitals
opt.updatetime = 200                                    -- Save swap file and trigger CursorHold
opt.signcolumn = "yes"
opt.completeopt = "menu,menuone,noselect,noinsert"
-- completeopt = { "menuone", "noinsert", "noselect" },
opt.termguicolors = true -- True color support
opt.undofile = true
opt.laststatus = 3       -- global statusline
opt.showmode = false     -- Dont show mode since we have a statusline
opt.showcmd = false
opt.ignorecase = true    -- Ignore case
opt.swapfile = false
opt.linebreak = true     -- Wrap lines at convenient points
opt.scrolloff = 4        -- Lines of context
opt.sidescrolloff = 8    -- Columns of context
opt.ruler = false        -- Disable the default ruler
--
opt.fileencodings = "utf-8,gbk"
opt.foldcolumn = '0'
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true

opt.mousemodel = "extend"
opt.mouse = ""

opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
opt.confirm = true   -- Confirm to save changes before exiting modified buffer
opt.fillchars = {
    foldopen = "",
    foldclose = "",
    fold = " ",
    foldsep = " ",
    diff = "╱",
    eob = " ",
}
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.jumpoptions = "view"
opt.pumblend = 10      -- Popup blend
opt.pumheight = 10     -- Maximum number of entries in a popup
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true  -- Round indent
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.smartindent = true -- Insert indents automatically

opt.spelllang = { "en", "cjk" }
opt.splitkeep = "screen"
opt.undolevels = 10000
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.winminwidth = 5       -- Minimum window width
opt.wrap = false          -- Disable line wrap
opt.winborder = 'rounded'
opt.textwidth = 80

opt.smoothscroll = true

vim.g.c_syntax_for_h = 0


-- opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
-- opt.foldmethod = "expr"
-- opt.foldtext = ""

-- opt.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"
-- opt.formatoptions = "jcroqlnt" -- tcqj
-- opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]

