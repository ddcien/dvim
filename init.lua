if vim.g.vscode then
    -- VSCode extension
else
    local utils = require("dvim.utils")

    if vim.g.neovide then
        vim.o.guifont = "Victor Mono" -- text below applies for VimScript
        vim.g.neovide_fullscreen = true
        vim.g.neovide_hide_mouse_when_typing = true
    end

    require("dvim.settings").load_default_options()

    local dvim_runtime_dir = utils.get_runtime_dir()
    local dvim_plugin_dir  = utils.join_paths(dvim_runtime_dir, "plugin")
    local dvim_config_dir  = utils.join_paths(dvim_runtime_dir, "config")
    local dvim_state_dir   = utils.join_paths(dvim_runtime_dir, "state")

    if not vim.tbl_contains(vim.opt.rtp:get(), dvim_runtime_dir) then
        vim.opt.rtp:prepend(dvim_runtime_dir)
    end

    local dvim_plug_lazy_dir = utils.join_paths(dvim_plugin_dir, "lazy.nvim")
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

    require("lazy").setup(
        -- require("dvim.plugins"),
        "dvim.plugins",
        {
            root     = dvim_plugin_dir,
            lockfile = utils.join_paths(dvim_config_dir, "lazy-lock.json"),
            state    = utils.join_paths(dvim_state_dir, "lazy", "state.json"),
            readme   = {
                enabled = false,
                root = utils.join_paths(dvim_state_dir, "lazy", "readme"),
            },
        }
    )

    vim.cmd [[colorscheme tokyonight]]
    -- vim.cmd [[colorscheme catppuccin]]
    --
    vim.g.UltiSnipsExpandTrigger = "<tab>"
    vim.g.UltiSnipsJumpForwardTrigger = "<c-b>"
    vim.g.UltiSnipsJumpBackwardTrigger = "<c-z>"
end
