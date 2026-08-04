-- Use space as leader key
vim.g.mapleader = " "

-- Spelling
-- :set spell spellang=en_us
vim.keymap.set("n", "<leader>zn", ":set spell<bar>normal! ]s<CR>", { desc = "next spelling" })
vim.keymap.set("n", "<leader>zp", ":set spell<bar>normal! [s<CR>", { desc = "prev spelling" })
vim.keymap.set("n", "<leader>zs", ":set spell<bar>normal! z=<CR>", { desc = "open spell suggestions" })
vim.keymap.set("n", "<leader>za", ":set spell<bar>normal! zg<CR>", { desc = "add spell to dict" }) -- zug to undo

-- Easy System-Clipboard copy/paste
vim.keymap.set({ "n", "x" }, "<leader>yy", '"+y', { desc = "Copy Vim -> System" })
vim.keymap.set({ "n", "x" }, "<leader>pp", '"+p', { desc = "Paste System -> Vim" })

vim.keymap.set({ "n", "x" }, "<leader>yx", '"*y', { desc = "Copy Vim -> X11" })
vim.keymap.set({ "n", "x" }, "<leader>px", '"*p', { desc = "Paste X11 -> Vim" })

vim.keymap.set({"n", "v"}, "<leader>x", '"_d"', { desc = "Void Delete (no Yank)"})

-- Easy Buffer navigation
vim.keymap.set("n", "<leader>ll", vim.cmd.bn, { desc = "Next Vim buffer" })
vim.keymap.set("n", "<leader>hh", vim.cmd.bp, { desc = "Prev Vim buffer" })

-- Tags
vim.keymap.set("n", "<leader>tj", "<C-]>", { desc = "{[T]ag [J]ump}" })

-- diff-mode (nvim -d)
vim.keymap.set("n", "<leader>hn", "]c<CR>", { desc = "[H]unk [N]ext" })
vim.keymap.set("n", "<leader>hp", "[c<CR>", { desc = "[H]unk [P]rev" })
-- :[range]diffg  Modify the current buffer to undo difference with another buffer
-- :[range]diffpu Modify another buffer to undo difference with the current buffer

-- Smart formatting
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

-- Copy and show filepath of current buffer
vim.keymap.set("n", "<leader>pf", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path) --copy filepath
	print("file:", path) -- show it
end, { desc = "[P]ath [F]ile Copy" })

-- Quickly remove trailing spaces
vim.keymap.set("n", "<leader>st", function()
    local view = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(view)
end, { desc = "[S]pace/[T]rim" })

-- Navigate merge conflicts
vim.keymap.set("n", "<leader>mn", function()
    vim.fn.search("^<<<<<<<\\|^=======\\|^>>>>>>>", "W")
end, { desc = "[M]erge conflict [N]ext" })

vim.keymap.set("n", "<leader>mp", function()
    vim.fn.search("^<<<<<<<\\|^=======\\|^>>>>>>>", "bW")
end, { desc = "[M]erge conflict [P]rev" })

-- Quality of life GIT functions
local blame_ns = vim.api.nvim_create_namespace('git_blame_line')

local function git_blame_line()
  local filepath = vim.api.nvim_buf_get_name(0)
  if filepath == '' then
    vim.notify('No file in buffer', vim.log.levels.WARN)
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  local dir = vim.fn.fnamemodify(filepath, ':h')

  local cmd = string.format(
    'git -C %s blame -L %d,%d --date=short -- %s',
    vim.fn.shellescape(dir),
    line, line,
    vim.fn.shellescape(vim.fn.fnamemodify(filepath, ':t'))
  )

  local result = vim.fn.systemlist(cmd)

  -- clear any previous blame virtual line in this buffer
  vim.api.nvim_buf_clear_namespace(bufnr, blame_ns, 0, -1)

  if vim.v.shell_error ~= 0 or #result == 0 then
    vim.notify('git blame failed (not tracked / no repo?)', vim.log.levels.ERROR)
    return
  end

  -- e.g. "abc1234 (Jane Doe 2026-07-30 12) some code here"
  local hash, author, date = result[1]:match('^%^?(%x+)%s+%((.-)%s+(%d%d%d%d%-%d%d%-%d%d)%s+%d+%)')

  if not hash then
    vim.notify('Could not parse blame output', vim.log.levels.ERROR)
    return
  end

  -- uncommitted lines show as all-zero hash
  if hash:match('^0+$') then
    vim.notify('Line not yet committed', vim.log.levels.INFO)
    return
  end

  -- Copy hash into clipboard
  vim.fn.setreg('+', hash)
  vim.fn.setreg('*', hash)

  local text = string.format('%s  %s  %s', hash, author, date)

  vim.api.nvim_buf_set_extmark(bufnr, blame_ns, line - 1, 0, {
    virt_lines = { { { text, 'Comment' } } },
    virt_lines_above = false,
  })
end

vim.keymap.set('n', '<leader>gbs', git_blame_line, { desc = '[g]it [b]lame [s]how current line (& copy hash)' })
vim.keymap.set('n', '<leader>gl', ":! git log -1 ", { desc = '[g]it [l]og (copy hash)' })

local function clear_blame()
    vim.api.nvim_buf_clear_namespace(0, blame_ns, 0, -1)
end
vim.keymap.set('n', '<leader>gbc', clear_blame, { desc = '[g]it [b]lame [c]lear' })

