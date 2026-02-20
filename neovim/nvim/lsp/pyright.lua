return {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },

    root_markers = {
        "pyproject.toml",
        "setup.py",
        "requirements.txt",
        ".git",
    },

    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
                typeCheckingMode = "standard",
                venvPath = vim.fs.normalize(vim.fn.expand('~')),
                venv = "py312",
                extraPaths = {vim.fs.joinpath(vim.fn.expand("~"), "gofer", "gofer")},
                logLevel = "Trace"
            },
        },
    },
}

