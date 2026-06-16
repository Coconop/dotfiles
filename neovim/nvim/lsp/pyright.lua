-- Look for custom config file on which virtual env to use
local function find_pyright_cfg()
  local dir = vim.fn.expand("%:p:h")
  local home = vim.fn.expand("~")

  while true do
    local cfg_path = dir .. "/.pyright_cfg.lua"
    if vim.fn.filereadable(cfg_path) == 1 then
      vim.notify("Found config: " .. cfg_path .. "]")
      return dofile(cfg_path) -- found: execute and return the config table
    end
    if dir == home then break end -- Do not walk up past HOME
    local parent = vim.fn.fnamemodify(dir, ":h")
    if parent == dir then break end  -- Do not walk up past ROOT
    dir = parent
  end

  return nil -- no config found :(
end

local cfg = find_pyright_cfg() or {}
vim.notify("[" .. cfg.venv .. "]" .. vim.inspect(cfg.extraPaths))

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

