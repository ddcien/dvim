return {
    dev = true,
    dir = '/work/ddcien/cmake-tools.nvim/',
    lazy = true,
    cmd = { 'CMakeGenerate', 'CMakeSelectCwd', 'CMakeGenerate', 'CMakeBuild', 'CMakeSelectCwd' },

    opts = {
        cmake_dap_configuration = {
            name = "cpp",
            type = "lldb",
            request = "launch",
            stopOnEntry = true,
            runInTerminal = true,
            console = "integratedTerminal",
        },
        cmake_kits_path = "~/.local/share/CMakeTools/cmake-tools-kits.json",
        cmake_use_scratch_buffer = true,
        build_options = { "-j8" },
    },
}
