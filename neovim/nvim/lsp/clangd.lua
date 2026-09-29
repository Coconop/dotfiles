return {
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--all-scopes-completion",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--fallback-style=llvm",
    },

    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },

    root_markers = {"compile_commands.json", "compile_flags.txt", ".git"},

    settings = {
        clangd = {
            InlayHints = {
                Designators = true,
                Enabled = true,
                ParameterNames = true,
                DeducedTypes = true,
            },
            fallbackFlags = { "-std=c++20" },
        },
    }
}
