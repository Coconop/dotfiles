
----
-- Netrw customization stolen from doom-nvim
-- https://github.com/doom-neovim/doom-nvim/blob/main/lua/doom/modules/features/netrw/init.lua
-- Just for nice UI when opening a directory, for the rest, use mini.files

vim.g.netrw_banner = 0

-- Keep the current directory and the browsing directory synced.
-- (avoid the move files error.)
vim.g.netrw_keepdir = 0

-- Show directories first (sorting)
vim.g.netrw_sort_sequence = [[[\/]$,*]]

-- Netrw list style
-- 0 : thin listing (one file per line)
-- 1 : long listing (one file per line with timestamp information and file size)
-- 2 : wide listing (multiple files in columns)
-- 3 : tree style listing
vim.g.netrw_liststyle = 3

-- Human-readable files sizes
vim.g.netrw_sizestyle = "H"

-- Show hidden files
-- 0 : show all files
-- 1 : show not-hidden files
-- 2 : show hidden files only
vim.g.netrw_hide = 0

-- Preview files in a vertical split window
vim.g.netrw_preview = 1

-- 0 = open files in the previous window (not split)
vim.g.netrw_browse_split = 0

-- When netrw open in split, use 25% of screen width
vim.g.netrw_winsize = 25

-- allow recursive directory deletion/copy
vim.g.netrw_localrmdir = 'rm -r'
vim.g.netrw_copydircmd = 'cp -r'

-- highlight special files (exe, links, etc)
vim.g.netrw_special_syntax = 1

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'netrw',
  desc = 'Netrw buffer-local keymaps',
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true }

    -- quick close with q, matching most tree plugins
    vim.keymap.set('n', 'q', '<cmd>close<CR>', opts)

    vim.keymap.set('n', '?', function()
      local lines = {
        ' Netrw cheatsheet ',
        '',
        ' Navigation',
        '   -        go up a directory',
        '   <CR>     open file/dir',
        '   u / U    go back / forward in history',
        '   gb       go to previously bookmarked dir',
        '',
        ' Marking files (visual selection across lines)',
        '   mf       mark/unmark file under cursor',
        '   mu       unmark all marked files',
        '   mF       mark files matching a pattern',
        '   mt       set the target directory (for copy/move)',
        '   mc       copy marked files to target',
        '   mm       move marked files to target',
        '   mx       execute a shell command on marked files',
        '   md       diff marked files',
        '',
        ' File/dir ops',
        '   %        create a new file',
        '   d        create a new directory',
        '   D        delete file/dir under cursor (or marked files)',
        '   R        rename file/dir under cursor (or marked files)',
        '   gp       chmod file under cursor',
        '',
        ' View',
        '   i        cycle listing style (thin/long/wide/tree)',
        '   s        cycle sort (name/time/size/ext)',
        '   r        reverse sort order',
        '',
        ' q  close this cheatsheet ',
      }
      local width = 0
      for _, l in ipairs(lines) do width = math.max(width, #l) end
      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      vim.bo[buf].modifiable = false
      local win = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = width + 2,
        height = #lines,
        row = math.floor((vim.o.lines - #lines) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        style = 'minimal',
        border = 'rounded',
        title = ' netrw help ',
        title_pos = 'center',
      })
      vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = buf })
      vim.keymap.set('n', '<Esc>', '<cmd>close<CR>', { buffer = buf })
    end, { buffer = ev.buf, silent = true, desc = 'Netrw cheatsheet' })

  end,
})

--- tree-sitter ----------------------------------------------------------------

-- Use bash grammar for sh scripts
vim.treesitter.language.register('bash', 'sh')
vim.treesitter.language.register('c_sharp', 'cs')
vim.treesitter.language.register('markdown', { 'pandoc', 'markdown.pandoc' })
-- vimdoc parser is used for :help buffers, filetype 'help'
vim.treesitter.language.register('vimdoc', 'help')

local ts_group = vim.api.nvim_create_augroup('ts-highlight', { clear = true })

local LARGE_FILE_SIZE = 1 * 1024 * 1024 -- 1MB

local function file_too_big(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  if name == '' then return false end
  local ok, stats = pcall(function() return vim.uv.fs_stat(name) end)
  return ok and stats ~= nil and stats.size > LARGE_FILE_SIZE
end

local function try_start_treesitter(buf, lang)
  local ok = pcall(vim.treesitter.start, buf, lang)
  return ok
end

vim.api.nvim_create_autocmd('FileType', {
  group = ts_group,
  callback = function(args)
    local buf = args.buf

    -- Exit early on non-file buffers (pickers, terminal, quickfix, etc)
    if vim.bo[buf].buftype ~= '' then return end

    -- always kill legacy syntax — never let it silently take over
    vim.bo[buf].syntax = 'OFF'

    if file_too_big(buf) then
      vim.b[buf].large_buf = true
      vim.cmd('NoMatchParen')
      return -- highlighting disabled entirely on large files
    end

    local ft = vim.bo[buf].filetype
    if ft == '' then return end

    local lang = vim.treesitter.language.get_lang(ft) or ft

    local started = try_start_treesitter(buf, lang)
    if not started then
      print(('no treesitter highlighting for "%s"'):format(lang))
    end
  end,
})


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
                    severity =
                            item.level == "error"
                            and vim.diagnostic.severity.ERROR
                        or
                            item.level == "warning"
                            and vim.diagnostic.severity.WARN
                        or
                            vim.diagnostic.severity.INFO,
                    message = item.message,
                    source = "shellcheck",
                })
            end

            local ns = vim.api.nvim_create_namespace("shellcheck")
            vim.diagnostic.reset(ns, bufnr)
            vim.diagnostic.set(ns, bufnr, diagnostics)
            vim.diagnostic.enable(true)
            vim.diagnostic.config({ virtual_text = false })
            vim.diagnostic.config({ virtual_lines = true })
            vim.diagnostic.jump({count=1, float=true})
        end,
    })
end, { desc = "[L]in[t]: [S]hellCheck"})

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
                    severity =
                        severity_map[priority] or vim.diagnostic.severity.WARN,
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
                local line_content =
                    vim.api.nvim_buf_get_lines(
                        buf, d.lnum, d.lnum + 1, false)[1] or ""
                -- find first non-space, convert to 0-indexed
                local col = line_content:find("%S") - 1
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
        vim.diagnostic.reset(ns, buf)
        vim.diagnostic.set(ns, buf, diags)
    end
end

vim.keymap.set("n", "<leader>ltc", function()
    local codenarc_dir = vim.fs.joinpath(vim.fn.expand("~"), "git", "codenarc")
    local jar = vim.fs.joinpath(codenarc_dir, "CodeNarc-3.7.0.jar")
    local deps_groovy = vim.fs.joinpath(codenarc_dir, "groovy", "*")
    local deps_slf4j = vim.fs.joinpath(codenarc_dir, "slf4j", "*")
    local deps_gmetrics =vim.fs.joinpath(codenarc_dir, "gmetrics", "*")
    -- \ on windows, / on unix
    local sep = package.config:sub(1,1) == "\\" and ";" or ":"
    local classpath = table.concat(
        {deps_groovy, deps_gmetrics, deps_slf4j, jar},
        sep)

    local codenarc_cmd = {
        "java",
        "-classpath",
        classpath,
        "org.codenarc.CodeNarc",
        "-rulesetfiles=" ..
            "rulesets/basic.xml" ..
            ",rulesets/groovyism.xml" ..
            ",rulesets/jenkins.xml",
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
                vim.notify("CodeNarc exited with code: " ..
                    code, vim.log.levels.ERROR)
            end
            -- send accumulated output to process
            set_diagnostics(table.concat(output_lines, "\n"))
        end,
    })

    vim.diagnostic.enable(true)
    vim.diagnostic.config({ virtual_text = false })
    vim.diagnostic.config({ virtual_lines = true })
    vim.diagnostic.jump({count=1, float=true})

end, { desc = "[L]in[t]: [C]odeNarc"})

-- Jenkins
local jenkins_ns = vim.api.nvim_create_namespace("jenkinsfile_lint")

vim.keymap.set("n", "<leader>ltj", function()
  local jenkins_url = os.getenv("JENKINS_URL")
  local jenkins_usr = os.getenv("JENKINS_USER_ID")
  local jenkins_api_tok = os.getenv("JENKINS_API_TOKEN")
  local jenkins_auth = jenkins_usr .. ":" .. jenkins_api_tok
  if not jenkins_url then
    vim.notify("JENKINS_URL not set", vim.log.levels.ERROR)
    return
  end
  if not jenkins_usr then
    vim.notify("JENKINS_USER_ID not set", vim.log.levels.ERROR)
    return
  end
  if not jenkins_api_tok then
    vim.notify("JENKINS_API_TOKEN not set", vim.log.levels.ERROR)
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local file = vim.api.nvim_buf_get_name(bufnr)
  if file == "" then
      vim.notify("Buffer has no file on disk", vim.log.levels.ERROR)
      return
  end

  vim.notify("Validating Jenkinsfile…", vim.log.levels.INFO)

  vim.system({
    "curl", "-sk", "-X", "POST",
    "--user", jenkins_auth,
    "-F", "jenkinsfile=<" .. file,
    jenkins_url .. "/pipeline-model-converter/validate",
  }, { text = true }, function(res)
    vim.schedule(function()

      if res.code ~= 0 then
        vim.notify("curl failed (exit " .. res.code .. "): " .. (res.stderr or ""), vim.log.levels.ERROR)
        return
      end

      local out = res.stdout or ""
      local diagnostics = {}

      -- Jenkins format: "WorkflowScript: 12: <msg> @ line 12, column 5."
      for lnum, msg, col in out:gmatch("WorkflowScript:%s*(%d+):%s*(.-)%s*@ line %d+, column (%d+)%.") do
        table.insert(diagnostics, {
          bufnr = bufnr,
          lnum = tonumber(lnum) - 1,
          col = tonumber(col) - 1,
          message = vim.trim(msg),
          severity = vim.diagnostic.severity.ERROR,
          source = "jenkinsfile-lint",
        })
      end

      -- Unparseable but non-success output: surface it as one diagnostic on line 1
      if #diagnostics == 0 and not out:match("successfully validated") then
        table.insert(diagnostics, {
          bufnr = bufnr, lnum = 0, col = 0,
          message = vim.trim(out),
          severity = vim.diagnostic.severity.ERROR,
          source = "jenkinsfile-lint",
        })
      end

      vim.diagnostic.set(jenkins_ns, bufnr, diagnostics)

      if #diagnostics == 0 then
        vim.notify("Jenkinsfile OK", vim.log.levels.INFO)
      else
        vim.notify(("Jenkinsfile: %d issue(s)"):format(#diagnostics), vim.log.levels.WARN)
      end
    end)
  end)
end, { desc = "[L]in[t] [j]enkins file" })

