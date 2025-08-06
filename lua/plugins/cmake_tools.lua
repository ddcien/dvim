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
        cmake_generate_options = {
            "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON",
            "-DCMAKE_BUILD_TYPE=Release"
        },
        build_options = { "-j8" },
    },
}
