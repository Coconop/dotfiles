-- highlight yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	pattern = "*",
	desc = "highlight selection on yank",
	callback = function()
		vim.highlight.on_yank({ timeout = 200, visual = true })
	end,
})

-- restore cursor to file position in previous editing session
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.api.nvim_win_set_cursor(0, mark)
			-- defer centering slightly so it's applied after render
			vim.schedule(function()
				vim.cmd("normal! zz")
			end)
		end
	end,
})

-- auto resize splits when the terminal's window is resized
vim.api.nvim_create_autocmd("VimResized", {
	command = "wincmd =",
})

-- no auto continue comments on new line
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("no_auto_comment", {}),
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

-- syntax highlighting for dotenv files
vim.api.nvim_create_autocmd("BufRead", {
	group = vim.api.nvim_create_augroup("dotenv_ft", { clear = true }),
	pattern = { ".env", ".env.*" },
	callback = function()
		vim.bo.filetype = "dosini"
	end,
})

-- show cursorline only in active window enable
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
	group = vim.api.nvim_create_augroup("active_cursorline", { clear = true }),
	callback = function()
		vim.opt_local.cursorline = true
	end,
})

-- spellcheck in md
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	command = "setlocal spell wrap",
})

-- Run ShellCheck for sh/bash scritps
if vim.fn.executable("shellcheck") == 1 then
  vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
    pattern = { "*.sh", "*.bash" },
    callback = function()
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
    end,
  })
else
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "sh", "bash" },
    once = true,
    callback = function()
      vim.notify("shellcheck not installed/in path", vim.log.levels.WARN)
    end,
  })
end
