-- Editor Options
vim.opt.number = true -- line number
vim.opt.relativenumber = false -- relative line numbers (set rnu to toggle)

vim.opt.expandtab = true -- Use spaces instead of actual \t
vim.opt.tabstop = 4 -- VISUAL \t spaces count
vim.opt.softtabstop = 4 -- INSERT \t spaces count
vim.opt.shiftwidth = 4 -- indent-format spaces count

vim.opt.autoindent = true -- Copy indent of current lien on new line
vim.opt.smartindent = true -- Inc/Dec new lines C-style (brackets, keywords...)

vim.opt.wrap = false -- Don't wrap, jump/search/vsp

vim.opt.hlsearch = true -- highlight matches
vim.opt.incsearch = true -- show partial matches as typing
vim.opt.ignorecase = true -- case insensitive search
vim.opt.smartcase = true -- switch to sensitive if an uppercase is used
vim.opt.path:append("**") -- recursive file search from CWD for find/gf

vim.opt.termguicolors = true -- enables 24-bit RGB color inthe TUI
vim.opt.scrolloff = 8 -- How many screen lines to keep above and below cursor
vim.opt.signcolumn = "yes" -- always show a sign column (for LSP/git/...)
vim.opt.iskeyword:append("-") -- include '-' in word text-object
vim.opt.cursorline = true -- highligh the line the cursor is on
vim.opt.colorcolumn = "80" -- The old school 80 char per line rule
vim.opt.listchars = { -- invisible chars to display (set list/nolist)
  tab = "| ",      -- tabs
  trail = "_",     -- trailing spaces
  extends = ">",   -- line extends past the window
  precedes = "<",  -- there's text before the window
  nbsp = "~",      -- Non-breaking space
  eol = "$",       -- Line feeds
}

vim.opt.updatetime = 1000 -- ms of inactivity before writing swap to disk
vim.opt.wildignore:append({-- ignore common directories
  "*/node_modules/*",
  "*/.git/*",
  "*/build/*",
  "*/dist/*",
})
vim.opt.wildmenu = true -- tab triggers completion
vim.opt.wildmode = { "longest:full", "full" } -- complete to longest match
vim.opt.wildoptions = { "pum" } -- show completion in pop-up menu

vim.opt.shortmess:append("I") -- no intro message on startup
vim.opt.autoread = true -- auto-reload changes outside of neovim

-- Save 'undo' actions in directory (create it if needed)
local undodir = vim.fn.expand("~/.config/nvim/undo")
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
end
vim.opt.undodir = undodir
vim.opt.undofile = true

-- Save swap files in specific directory (create it if needed)
local swapdir = vim.fn.expand("~/.config/nvim/swap")
if vim.fn.isdirectory(swapdir) == 0 then
    vim.fn.mkdir(swapdir, "p")
end
vim.opt.directory = swapdir .. '//'
vim.opt.swapfile = true

-- Store backups in specific directory (create if needed)
local backupdir = vim.fn.expand("~/.config/nvim/backup")
if vim.fn.isdirectory(backupdir) == 0 then
    vim.fn.mkdir(backupdir, "p")
end
vim.opt.backupdir = backupdir
vim.opt.backup = true


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
  elseif has_command('win32yank') then
      vim.g.clipboard = {
        name = "win32yank",
        copy = {
          ["+"] = "win32yank.exe -i --crlf",
          ["*"] = "win32yank.exe -i --crlf",
        },
        paste = {
          ["+"] = "win32yank.exe -o --lf",
          ["*"] = "win32yank.exe -o --lf",
        },
        cache_enabled = 0,
      }
  else
    vim.opt.clipboard:append("unnamedplus")
    print("options.lua: Ooops! No clipboard binary found: using built-in.")
  end
end

-- .h file use C filetype instead of C++
vim.g.c_syntax_for_h = 1


