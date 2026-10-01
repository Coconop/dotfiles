local cfg = janus and janus.pyright or {}
vim.notify("Virtual env: " .. vim.inspect(cfg.venv), vim.log.levels.DEBUG)
vim.notify("Extra Paths: " .. vim.inspect(cfg.extraPaths), vim.log.levels.TRACE)

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

