local M = {}

function M.is_directory(path)
    local stat = vim.loop.fs_stat(path)
    return stat and stat.type == "directory" or false
end

function M.join_paths(...)
    return table.concat({ ... }, "/")
end

function M.get_runtime_dir()
    local _dir = os.getenv("DVIM_RUNTIME_DIR")
    if _dir then
        return _dir
    end
    return M.join_paths(vim.fn.stdpath("config"), "dvim")
end

function M.get_config_dir()
    local _dir = os.getenv("DVIM_CONFIG_DIR")
    if _dir then
        return _dir
    end
    return vim.fn.stdpath("config")
end

function M.get_cache_dir()
    local _dir = os.getenv "DVIM_CACHE_DIR"
    if _dir then
        return _dir
    end
    return vim.fn.stdpath("cache")
end

return M
