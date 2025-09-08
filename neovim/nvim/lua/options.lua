vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.cursorline = true

vim.opt.colorcolumn = "80"

-- Suppresses the intro message on startup
vim.opt.shortmess:append("I")

local undodir = vim.fn.expand("~/.config/nvim/undo")
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
end
vim.opt.undodir = undodir
vim.opt.undofile = true

local swapdir = vim.fn.expand("~/.config/nvim/swap")
if vim.fn.isdirectory(swapdir) == 0 then
    vim.fn.mkdir(swapdir, "p")
end
vim.opt.directory = swapdir .. '//'
vim.opt.swapfile = true

local backupdir = vim.fn.expand("~/.config/nvim/backup")
if vim.fn.isdirectory(backupdir) == 0 then
    vim.fn.mkdir(backupdir, "p")
end
vim.opt.backupdir = backupdir
vim.opt.backup = true

vim.opt.listchars = {
  tab = "| ",      -- tabs
  trail = "_",     -- trailing spaces
  extends = ">",   -- line extends past the window
  precedes = "<",  -- there's text before the window
  nbsp = "~",      -- Non-breaking space
  eol = "$",       -- Line feeds
}

-- Netrw customization stolen from doom-nvim
-- https://github.com/doom-neovim/doom-nvim/blob/main/lua/doom/modules/features/netrw/init.lua
-- Just for nice UI when opening a directory, for the rest, use mini.files

-- Keep the current directory and the browsing directory synced.
-- This helps you avoid the move files error.
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

--------------------------------------------------------------------------------

-- TODO copy function to handle icons

-- Clipboard configuration
-- '+' system clipboard register (C-c / C-V)
-- '*' priamry selection register (select with mouse / middleclick)

local function is_tmux()
  return vim.env.TMUX ~= nil
end

if is_tmux() then
  vim.g.clipboard = {
    name = 'tmux',
    copy = {
      ['+'] = {'tmux', 'load-buffer', '-'},
      ['*'] = {'tmux', 'load-buffer', '-'},
    },
    paste = {
      ['+'] = {'tmux', 'save-buffer', '-'},
      ['*'] = {'tmux', 'save-buffer', '-'},
    },
    cache_enabled = true,
  }
else
  -- X11 clipboard configuration
  local function has_command(cmd)
    return vim.fn.executable(cmd) == 1
  end

  if has_command('xclip') then
    vim.g.clipboard = {
      name = 'xclip',
      copy = {
        ['+'] = {'xclip', '-quiet', '-i', '-selection', 'clipboard'},
        ['*'] = {'xclip', '-quiet', '-i', '-selection', 'primary'},
      },
      paste = {
        ['+'] = {'xclip', '-o', '-selection', 'clipboard'},
        ['*'] = {'xclip', '-o', '-selection', 'primary'},
      },
      cache_enabled = true,
    }
  elseif has_command('xsel') then
    vim.g.clipboard = {
      name = 'xsel',
      copy = {
        ['+'] = {'xsel', '--nodetach', '--input', '--clipboard'},
        ['*'] = {'xsel', '--nodetach', '--input', '--primary'},
      },
      paste = {
        ['+'] = {'xsel', '--output', '--clipboard'},
        ['*'] = {'xsel', '--output', '--primary'},
      },
      cache_enabled = true,
    }
  else
    vim.opt.clipboard:append("unnamedplus")
    print("Warning: Neither xclip nor xsel found. Using built-in clipboard.")
  end
end

-- .h file use C filetype instead of C++
vim.g.c_syntax_for_h = 1


