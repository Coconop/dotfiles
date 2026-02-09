-- Search for a virtual env recursively from HOME
local function find_venv()
    local venv = vim.fs.find(
        -- Python virtual env contain pyvenv.cfg on both windows and linux
        { "pyvenv.cfg" },
        {
            path = vim.fn.expand('~'),
        }
    )[1]

    if venv then
        return vim.fs.dirname(venv)
    end
end

local venv = find_venv()
local extra_src = "."
if venv then
    extra_src = vim.fs.find(
        {"gofer"},
        {path=venv})
end

return {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },

    root_markers = {
        "pyproject.toml",
        "setup.py",
        "requirements.txt",
        ".git",
    },

    before_init = function(_, config)

        if venv then
            config.settings = config.settings or {}
            config.settings.python = config.settings.python or {}

            config.settings.python.pythonPath =
                vim.fs.joinpath(venv, "bin", "python") -- linux/mac


            if vim.loop.os_uname().sysname == "Windows_NT" then
                config.settings.python.pythonPath =
                    vim.fs.joinpath(venv, "Scripts", "python.exe")
            end
        end
    end,

    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
                typeCheckingMode = "standard",
                extraPaths = extra_src,
            },
        },
    },
}

