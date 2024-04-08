" All system-wide defaults are set in $VIMRUNTIME/debian.vim (usually just
" /usr/share/vim/vimcurrent/debian.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
" do it in this file (/etc/vim/vimrc), since debian.vim will be overwritten
" everytime an upgrade of the vim packages is performed.  It is recommended to
" make changes after sourcing debian.vim since it alters the value of the
" 'compatible' option.

" ========== Debian compatibility =============================================
" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
"runtime! debian.vim

" Use Vim settings, rather then Vi settings (much better!).
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
set nocompatible

" === Colors
set termguicolors
set term=xterm-256color
set background=dark
colorscheme codedark

" === General config
set showcmd         " Show (partial) command in status line.
set showmatch       " Show matching brackets.
set ignorecase      " Case does not matter...
set smartcase       " Unless we search for uppercase!
set incsearch       " Incremental search
set mouse=a         " Enable mouse usage (all modes)
set cursorline      " Show current line
set ruler           " Show ruler and commands
set backspace=indent,eol,start " Make backspace work in insert mode
set visualbell      " Deactivate sound and flash instead (flash not working)
set hls             " Highlight search
set showmode        " Show current mode down the bottom
set number          " Show current line number
set relativenumber  " Show relative numbers around

"=== Indentation
set expandtab       "Use spaces rather than tabulations
" Now we can replace tabs by spaces with :retab
set shiftwidth=4
set softtabstop=4
set tabstop=4

"=== Formatting & syntax
syntax enable

" Highlight Tabulations

" Noob way
"highlight NoTabs ctermbg=red ctermfg=white guibg=#592929
"highlight ExtraWhitespace ctermbg=red ctermfg=white guibg=#592929
"match NoTabs /\t/
"match ExtraWhitespace /\s\+$/

" Expert way
set nolist
set listchars=tab:▸\ ,eol:¬,trail:·,nbsp:·
hi NonText guifg=#fff2cc
hi SpecialKey guifg=#fff2cc

" Vertical ruler
"set colorcolumn=80
highlight ColorColumn ctermbg=235 guibg=#303030

"=== Persistence
" Keep undo history across sessions, by storing in file.
" Only works all the time.
silent !mkdir ~/.vim/backups > /dev/null 2>&1
set undodir=~/.vim/backups
set undofile
set history=1000                "Store lots of :cmdline history

" Jump to the last position when reopening a file
if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

"=== StatusLine (Warning: can be in conflict with lightline plugin)
"set statusline=2
set noshowmode

"=== Buffer
" :e to edit
" :b <Tab> to cycle around buffers
" :bd to close a buffer

"=== Tabs
" :tabe Open new tab
" :tabc Close current tab
" gt    Next tab
" gT    Prev tab

"=== Rust
packadd termdebug
let g:termdebugger="rust-gdb"
let g:termdebug_wide=1

"=== Plugins
source ~/.vim/plugin/my_plugins.vim
