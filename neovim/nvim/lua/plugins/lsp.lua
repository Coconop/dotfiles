local add, later = MiniDeps.add, MiniDeps.later

-- Global lsp config -----------------------------------------------------------

-- Always let space for diagnostics, signs, etc
vim.opt.signcolumn = "yes"

-- Setup keymaps etc ONLY if there is an attached LSP
vim.api.nvim_create_autocmd("LspAttach", {
    desc = "LSP actions",

    callback = function(event)

        vim.keymap.set("n", "<leader>ld", function()
            require("fzf-lua").lsp_definitions()
        end, {buffer = event.buf, desc = "[L]SP goto [d]efinition" })

        vim.keymap.set("n", "<leader>lD", function()
            vim.lsp.buf.declaration()
        end, {buffer = event.buf, desc = "[L]SP goto [D]eclaration" })

        vim.keymap.set("n", "<leader>lr", function()
            require("fzf-lua").lsp_references()
        end, {buffer = event.buf, desc = "[L]SP [r]eferences" })

        vim.keymap.set("n", "<leader>lI", function()
            require("fzf-lua").lsp_implementations()
        end, {buffer = event.buf, desc = "[L]SP [I]mplementations" })

        vim.keymap.set("n", "<leader>lt", function()
            require("fzf-lua").lsp_typedefs()
        end, {buffer = event.buf, desc = "[L]SP [t]ypedefs" })

        vim.keymap.set("n", "<leader>lR", function()
            vim.lsp.buf.rename()
        end, {buffer = event.buf, desc = "[L]SP [R]ename" })

        vim.keymap.set("n", "<leader>la", function()
            vim.lsp.buf.code_action()
        end, {buffer = event.buf, desc = "[L]SP code [A]ction" })

        vim.keymap.set("n", "<leader>lci", function()
            require("fzf-lua").lsp_incoming_calls()
        end, {buffer = event.buf, desc = "[L]SP [C]allstack [I]ncoming" })

        vim.keymap.set("n", "<leader>lco", function()
            require("fzf-lua").lsp_outgoing_calls()
        end, {buffer = event.buf, desc = "[L]SP [C]allstack [O]utgoing" })

        vim.keymap.set("n", "<leader>lh", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            vim.notify(vim.lsp.inlay_hint.is_enabled() and "Inlay Hints Enabled" or "Inlay Hints Disabled")
        end, {buffer = event.buf, desc = "[L]SP inlay [H]ints toggle" })

    end
})

-- Diagnostics -----------------------------------------------------------------

vim.keymap.set("n", "<leader>dt", function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
    vim.notify(vim.diagnostic.is_enabled() and "Diagnostics Enabled" or "Diagnostics Disabled")
end, { desc = "[D]iagnostic [T]oggle" })

-- navigate diagnostics
vim.keymap.set("n", "<leader>dn", function()
    vim.diagnostic.jump({count=1, float=true}) end,
    {desc = "[D]iagnostic [N]ext "})
vim.keymap.set("n", "<leader>dp", function()
    vim.diagnostic.jump({count=-1, float=true}) end,
    {desc = "[D]iagnostic [P]rev"})
vim.keymap.set("n", "<leader>dl", function()
    require("fzf-lua").diagnostics_document()
end, { desc = "[D]iagnostic [L]ist" })

-- UI render
vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
        },
        -- Highlight entire line for errors
        linehl = {
            [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
        },
        -- Highlight the line number for warnings
        numhl = {
            [vim.diagnostic.severity.WARN] = 'WarningMsg',
        },
    },
    -- No distraction by default
    virtual_text = false,
    virtual_lines = false,
    underline = true,
})

vim.keymap.set({ "n", "x" }, "<leader>dvt", function()
    local current = vim.diagnostic.config().virtual_text
    vim.diagnostic.config({ virtual_text = not current })
    print("virtual_text: " .. tostring(not current))
end, {desc = "[D]iagnostic [V]irtual [T]ext toogle"})

vim.keymap.set({ "n", "x" }, "<leader>dvl", function()
    local current = vim.diagnostic.config().virtual_lines
    vim.diagnostic.config({ virtual_lines = not current })
    print("virtual_lines: " .. tostring(not current))
end, {desc = "[D]iagnostic [V]irtual [L]ines toogle"})

vim.keymap.set({ "n", "x" }, "<leader>du", function()
    local current = vim.diagnostic.config().underline
    vim.diagnostic.config({ underline = not current })
    print("underline: " .. tostring(not current))
end, {desc = "[D]iagnostic [U]nderline toogle"})


-- Global clear (all namespaces)
vim.keymap.set("n", "<leader>dc", function()
    vim.diagnostic.reset(nil, 0)
end, { desc = "[D]iagnostic [C]lear"})


--- Lsp toogle (disabled by default for fast edit) -----------------------------

vim.keymap.set("n", "<leader>lg", function()
    vim.notify("Enabling LSP")
    vim.lsp.enable('rust_analyzer')
    vim.lsp.enable('clangd')
    vim.lsp.enable('lua_ls')
    vim.lsp.enable('pyright')
    -- vim.lsp.enable('groovyls')
end, { desc = "[L]SP [g]o"})

vim.keymap.set("n", "<leader>lx", function()
    vim.notify("Disabling LSP")
    for _, client in ipairs(vim.lsp.get_clients()) do
        client.stop()
    end
    vim.lsp.enable('rust_analyzer', false)
    vim.lsp.enable('clangd', false)
    vim.lsp.enable('lua_ls', false)
    vim.lsp.enable('pyright', false)
    -- vim.lsp.enable('groovyls', false)
end, { desc = "[L]SP e[x]it"})

--- Linters --------------------------------------------------------------------

--- ShellCheck
vim.keymap.set("n", "<leader>lts", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local filename = vim.api.nvim_buf_get_name(bufnr)

  vim.fn.jobstart({ "shellcheck", "--format=json", filename }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if not data then return end
      local output = table.concat(data, "\n")
      local ok, result = pcall(vim.fn.json_decode, output)
      if not ok or not result then return end

      local diagnostics = {}
      for _, item in ipairs(result) do
        table.insert(diagnostics, {
          lnum = item.line - 1,
          col = item.column - 1,
          end_lnum = item.endLine - 1,
          end_col = item.endColumn,
          severity = item.level == "error" and vim.diagnostic.severity.ERROR
                  or item.level == "warning" and vim.diagnostic.severity.WARN
                  or vim.diagnostic.severity.INFO,
          message = item.message,
          source = "shellcheck",
        })
      end

      vim.diagnostic.set(vim.api.nvim_create_namespace("shellcheck"), bufnr, diagnostics)
    end,
  })
end, { desc = "Lint: [S]hellCheck"})

--- CodeNarc
local function parse_codenarc(output)
    local diagnostics = {}
    local current_file = nil

    -- P1=Error, P2=Warning, P3=Info
    local severity_map = {
        ["1"] = vim.diagnostic.severity.ERROR,
        ["2"] = vim.diagnostic.severity.WARN,
        ["3"] = vim.diagnostic.severity.INFO,
    }

    for line in output:gmatch("[^\r\n]+") do
        -- Match file line
        local file = line:match("^File: (.+)$")
        if file then
            -- Normalize path separators
            current_file = file:gsub("\\", "/")

        -- Match violation line
        elseif current_file then
            local rule, priority, lnum, msg =
            line:match("Violation: Rule=(%S+) P=(%d) Line=(%d+) Msg=%[(.-)%]")
            if rule and priority and lnum and msg then
                table.insert(diagnostics, {
                    file = current_file,
                    lnum = tonumber(lnum) - 1,  -- Neovim is 0-indexed
                    col = 0,
                    severity = severity_map[priority] or vim.diagnostic.severity.WARN,
                    message = string.format("[%s] %s", rule, msg),
                    source = "codenarc",
                })
            end
        end
    end

    return diagnostics
end

local function set_diagnostics(output)
    local ns = vim.api.nvim_create_namespace("codenarc")
    local diagnostics_by_buf = {}

    for _, d in ipairs(parse_codenarc(output)) do
        -- Find buffer by filename match
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            local buf_name = vim.api.nvim_buf_get_name(buf):gsub("\\", "/")
            if buf_name:find(d.file, 1, true) then
                diagnostics_by_buf[buf] = diagnostics_by_buf[buf] or {}
                local line_content = vim.api.nvim_buf_get_lines(buf, d.lnum, d.lnum + 1, false)[1] or ""
                local col = line_content:find("%S") - 1  -- find first non-space, convert to 0-indexed
                table.insert(diagnostics_by_buf[buf], {
                    lnum     = d.lnum,
                    col      = col,
                    severity = d.severity,
                    message  = d.message,
                    source   = d.source,
                })
                break
            end
        end
    end

    -- Clear old diagnostics and set new ones
    for buf, diags in pairs(diagnostics_by_buf) do
        vim.diagnostic.set(ns, buf, diags)
    end
end

vim.keymap.set("n", "<leader>ltx", function()
  local nsc = vim.api.nvim_create_namespace("codenarc")
  local nss = vim.api.nvim_create_namespace("shellcheck")
  vim.diagnostic.reset(ns, vim.api.nvim_get_current_buf())
end, { desc = "Lint: Clear diagnostics" })

vim.keymap.set("n", "<leader>ltc", function()
    local codenarc_dir = vim.fs.joinpath(vim.fn.expand("~"), "git", "codenarc")
    local jar = vim.fs.joinpath(codenarc_dir, "CodeNarc-3.7.0.jar")
    local deps_groovy = vim.fs.joinpath(codenarc_dir, "groovy", "*")
    local deps_slf4j = vim.fs.joinpath(codenarc_dir, "slf4j", "*")
    local deps_gmetrics =vim.fs.joinpath(codenarc_dir, "gmetrics", "*")
    local sep = package.config:sub(1,1) == "\\" and ";" or ":" -- \ on windows, / on unix
    local classpath = table.concat({deps_groovy, deps_gmetrics, deps_slf4j, jar}, sep)

    local codenarc_cmd = {
        "java",
        "-classpath",
        classpath,
        "org.codenarc.CodeNarc",
        "-rulesetfiles=rulesets/basic.xml,rulesets/groovyism.xml,rulesets/jenkins.xml",
        "-sourcefiles=" .. vim.api.nvim_buf_get_name(0),
        "-report=console",
    }

    vim.notify("CodeNarc Linting...")
    local output_lines = {}
    vim.fn.jobstart(codenarc_cmd, {
        on_stdout = function(_, data)
            -- Stream stdout because it is slow
            for _, line in ipairs(data) do
                if line ~= "" then
                    vim.notify(line)
                    table.insert(output_lines, line)
                end
            end
        end,
        on_stderr = function(_, data)
            for _, line in ipairs(data) do
                if line ~= "" then
                    vim.notify(line, vim.log.levels.WARN)
                end
            end
        end,
        on_exit = function(_, code)
            if code ~= 0 then
                vim.notify("CodeNarc exited with code: " .. code, vim.log.levels.ERROR)
            end
            -- send accumulated output to process
            set_diagnostics(table.concat(output_lines, "\n"))
        end,
    })

    vim.diagnostic.enable(true)
    vim.diagnostic.config({ virtual_lines = true })

end, { desc = "Lint: [C]odeNarc"})

-- Jenkins
later(function()
    add({
        source = "ckipp01/nvim-jenkinsfile-linter",
        depends = {"nvim-lua/plenary.nvim"}
    })

    local linter = require('jenkinsfile_linter')

    vim.keymap.set('n', '<leader>ltj', function()
        vim.diagnostic.enable(true)
        vim.diagnostic.config({ virtual_text = true })
        linter.validate()
        vim.diagnostic.jump({count=1, float=true})
    end, { desc = "Lint: [J]enkins" })

end)
