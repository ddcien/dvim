vim.deprecate = function() end

if vim.g.vscode then
    return
end

if vim.g.neovide then
    vim.o.guifont = "Victor Mono"
end

require("dvim.settings").load_default_options()

local utils              = require("dvim.utils")
local dvim_runtime_dir   = utils.get_runtime_dir()
local dvim_plugin_dir    = utils.join_paths(dvim_runtime_dir, "plugin")
local dvim_config_dir    = utils.join_paths(dvim_runtime_dir, "config")
local dvim_state_dir     = utils.join_paths(dvim_runtime_dir, "state")
local dvim_plug_lazy_dir = utils.join_paths(dvim_plugin_dir, "lazy.nvim")

if not vim.tbl_contains(vim.opt.rtp:get(), dvim_runtime_dir) then
    vim.opt.rtp:prepend(dvim_runtime_dir)
end

if not utils.is_directory(dvim_plug_lazy_dir) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        dvim_plug_lazy_dir,
    })
end
vim.opt.rtp:prepend(dvim_plug_lazy_dir)

require("lazy").setup({
    spec     = require("dvim.plugins").get_plugins({
        use_native_lsp = true,
        use_blink_cmp = true,
    }),
    root     = dvim_plugin_dir,
    lockfile = utils.join_paths(dvim_config_dir, "lazy-lock.json"),
    state    = utils.join_paths(dvim_state_dir, "lazy", "state.json"),
    readme   = { enabled = false, },
})
vim.cmd [[colorscheme tokyonight]]

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>')
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.lds" },
    callback = function(ev)
        vim.api.nvim_set_option_value("filetype", "ld", { buf = ev.buf })
    end
})
