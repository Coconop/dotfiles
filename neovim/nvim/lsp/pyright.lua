local cfg = janus and janus.pyright or {}

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
                venvPath = cfg.venvPath,
                venv = cfg.venv,
                extraPaths = cfg.extraPaths,
                logLevel = "Trace"
            },
        },
    },
}

