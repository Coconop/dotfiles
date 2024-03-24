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
colorscheme iceberg

" === Cscope: C file indexer

" The following maps all invoke one of the following cscope search types:                 
"   's'   symbol: find all references to the token under cursor
"   'g'   global: find global definition(s) of the token under cursor
"   'c'   calls:  find all calls to the function name under cursor
"   't'   text:   find all instances of the text under cursor
"   'e'   egrep:  egrep search for the word under cursor
"   'f'   file:   open the filename under cursor
"   'i'   includes: find files that include the filename under cursor
"   'd'   called: find functions that function under cursor calls
"
" This tests to see if vim was configured with the '--enable-cscope' option
" when it was compiled.  If it wasn't, time to recompile vim... 
if has("cscope")

    """"""""""""" Standard cscope/vim boilerplate

    " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
    set cscopetag

    " check cscope for definition of a symbol before checking ctags: set to 1
    " if you want the reverse search order.
    set csto=0

    " add any cscope database in current directory
    if filereadable("cscope.out")
        cs add cscope.out  
    " else add the database pointed to by environment variable 
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif

    " show msg when any other cscope db added
    set cscopeverbose 

    " * Open search in current window (Ctrl+f)
    nmap <C-f>s :cs find s <C-R>=expand("<cword>")<CR><CR>  
    nmap <C-f>g :cs find g <C-R>=expand("<cword>")<CR><CR>  
    nmap <C-f>c :cs find c <C-R>=expand("<cword>")<CR><CR>  
    nmap <C-f>t :cs find t <C-R>=expand("<cword>")<CR><CR>  
    nmap <C-f>e :cs find e <C-R>=expand("<cword>")<CR><CR>  
    nmap <C-f>f :cs find f <C-R>=expand("<cfile>")<CR><CR>  
    nmap <C-f>i :cs find i <C-R>=expand("<cfile>")<CR><CR>  
    nmap <C-f>d :cs find d <C-R>=expand("<cword>")<CR><CR> 
    " * Open search result in a new tab
    nmap <C-@>s :tab cs find s <C-R>=expand("<cword>")<CR><CR> 
    nmap <C-@>g :tab cs find g <C-R>=expand("<cword>")<CR><CR> 
    nmap <C-@>c :tab cs find c <C-R>=expand("<cword>")<CR><CR> 
    nmap <C-@>t :tab cs find t <C-R>=expand("<cword>")<CR><CR> 
    nmap <C-@>e :tab cs find e <C-R>=expand("<cword>")<CR><CR> 
    nmap <C-@>f :tab cs find f <C-R>=expand("<cfile>")<CR><CR> 
    nmap <C-@>i :tab cs find i <C-R>=expand("<cfile>")<CR><CR> 
    nmap <C-@>d :tab cs find d <C-R>=expand("<cword>")<CR><CR> 
endif

" === General config
set showcmd         " Show (partial) command in status line.
set showmatch       " Show matching brackets.
set smartcase       " Do smart case matching
set incsearch       " Incremental search
set mouse=a         " Enable mouse usage (all modes)
set cursorline      " Show current line
set ruler           " Show ruler and commands
set backspace=indent,eol,start " Make backspace work in insert mode
set visualbell      " Deactivate sound and flash instead (flash not working)
set hls             " Highlight search
set showmode        " Show current mode down the bottom
set number          " Show line number

"=== Indentation
set expandtab       "Use spaces rather than tabulations
" Now we can replace tabs by spaces with :retab
set shiftwidth=4
set softtabstop=4
set tabstop=4

"=== Formatting & syntax 
" Highlight Tabulations
highlight NoTabs ctermbg=red ctermfg=white guibg=#592929
match NoTabs /\t/
" Vertical ruler
set colorcolumn=80
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

