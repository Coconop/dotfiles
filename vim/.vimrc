" Standalone .vimrc - no plugins required

set nocompatible            " This ain't vi

" -------------------------
" Basic UI / editing prefs
" -------------------------
if has("termguicolors")
  set termguicolors
endif

" terminal default (harmless if unsupported)
set term=xterm-256color
set background=dark
set t_Co=256           " Support 256 colors


" General settings
set iskeyword+=-        " Treat dash separated words as a word text object "
syntax enable           " Enables syntax highlighing
set hidden              " Required to keep multiple buffers open
set nowrap              " Display long lines as just one line
set encoding=utf-8      " The encoding displayed
set fileencoding=utf-8  " The encoding written to file
set splitbelow         " Horizontal splits will automatically be below
set splitright         " Vertical splits will automatically be to the right
set shortmess+=c       " Don't pass messages to |ins-completion-menu|

" Searching / editing
set incsearch           " Show search while typing
set ignorecase
set smartcase
set hlsearch            " Highlight search results
set showcmd
set showmode
set showmatch
set mouse=a             " We never know...
set clipboard=unnamed,unnamedplus   " best-effort; harmless if not available
set conceallevel=0      " So that I can see `` in markdown files

" Cursor / numbers
"set signcolumn=yes      " Always show the signcolumn, don't shift text
set cursorline          " Highlight current line
set number              " Show current line number
set relativenumber      " Show relative number for fast jumps/actions
set ruler               " Show cursor position at all time

" Key timeout for multi-key mappings
set timeout
set timeoutlen=1000
set ttimeoutlen=100
set updatetime=300                          " Faster completion
set completeopt=menuone,noinsert,noselect   " Customize completions

" Leader
let mapleader = "\<Space>"
nnoremap <Space> <Nop>

" Backspace behavior
set backspace=indent,eol,start

" Visual bell instead of beep
set visualbell

" Indentation - C-friendly defaults
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set smartindent
set autoindent
set showtabline=2   "Always show tablines

" Show listchars (tabs/trailers) but don't show them by default
set nolist
set listchars=tab:->,eol:$,trail:.,nbsp:_

" Vertical background column
set colorcolumn=80

" Better history
set history=1000

" Status line
set noshowmode      " Mode shall be in statusline
set laststatus=2    "Always show status line

" -------------------------
" Persistence (undo history)
" -------------------------
" Create a portable undodir and enable undofile.
" Use Vim's mkdir() so it works on Windows and Unix.
let s:undo_dir = expand('~/.vim/undodir//')
call mkdir(fnamemodify(s:undo_dir, ':p'), 'p')
" Use the directory (the trailing // is recommended)
let &undodir = s:undo_dir
set undofile

" -------------------------
" Reopen last edit position
" -------------------------
if has("autocmd")
  augroup vimrc-restore-cursor
    autocmd!
    autocmd BufReadPost *
          \ if line("'\"") > 1 && line("'\"") <= line("$") |
          \   exe "normal! g'\"" |
          \ endif
  augroup END
endif

" -------------------------
" Minimal nord-like palette
" -------------------------
set background=dark
hi clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name = 'nord-fallback'

" core
hi Normal       guifg=#D8DEE9 guibg=#2E3440
hi CursorLine   guibg=#3B4252
hi LineNr       guifg=#4C566A guibg=#2E3440
hi CursorLineNr guifg=#EBCB8B
hi Comment      guifg=#616E88 gui=italic
hi Constant     guifg=#88C0D0
hi Identifier   guifg=#EBCB8B
hi Statement    guifg=#B48EAD
hi PreProc      guifg=#BF616A
hi Type         guifg=#5E81AC
hi Special      guifg=#A3BE8C
hi Todo         guifg=#D08770 guibg=#3B4252 gui=bold
hi Visual       guibg=#434C5E
hi Search       guifg=#2E3440 guibg=#EBCB8B
hi StatusLine   guifg=#ECEFF4 guibg=#4C566A
hi VertSplit    guifg=#3B4252 guibg=#3B4252
hi Pmenu        guifg=#ECEFF4 guibg=#3B4252
hi PmenuSel     guifg=#2E3440 guibg=#88C0D0
hi ColorColumn  guibg=#303030

" --------------
" Customizations
" --------------
filetype plugin indent on
" Don't auto-wrap comments and don't insert comment leader after hitting 'o'
autocmd FileType * setlocal formatoptions-=c formatoptions-=o
" But insert comment leader after hitting <CR>
autocmd FileType * setlocal formatoptions+=r

" Search recursively with find
set path+=**
" Use tab to cycle through partial matches
set wildmenu
" Jump to tags
nnoremap <leader>cd <C-]>
" Jump back with C-O

" -------------------------
" Bindings
" -------------------------

" Write file as root from sudo (useful when editing system files)
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Sweet buffer browsing
nnoremap <leader>hh :bprevious<CR>
nnoremap <leader>ll :bnext<CR>
" Picker muscle memory
nnoremap <silent> <Leader>ee :Explore<CR>
nnoremap <silent> <Leader>ff :find
nnoremap <silent> <Leader>fb :ls<CR>:buffer

" Toggle zoom
function! ToggleZoom()
  if exists("t:zoomed")
    " Restore previous layout
    execute "wincmd ="
    unlet t:zoomed
  else
    " Maximize current window
    let t:zoomed = 1
    execute "wincmd _"
    execute "wincmd |"
  endif
endfunction
nnoremap <leader>z :call ToggleZoom()<CR>


" Reselect previously changed, put or yanked text
nnoremap gV `[v`]

" Make `q:` do nothing instead of opening command-line-window, because it is
" often hit by accident
" Use c_CTRL-F or fzf's analogue
nnoremap q: <nop>

" ------------------------------- STATUSLINE  ----------------------------------
" Custom statusline {{{
" Helper functions
function s:IsTruncated(width)
  return winwidth(0) < a:width
endfunction

function IsTruncated(width)
  return winwidth(0) < a:width
endfunction

function s:IsntNormalBuffer()
  " For more information see ':h buftype'
  return &buftype != ''
endfunction

function s:CombineSections(sections)
  let l:res = ''
  for s in a:sections
    if type(s) == v:t_string
      let l:res = l:res . s
    elseif s['string'] != ''
      if s['hl'] != v:null
        let l:res = l:res . printf('%s %s ', s['hl'], s['string'])
      else
        let l:res = l:res . printf('%s ', s['string'])
      endif
    endif
  endfor

  return l:res
endfunction

" MiniStatusline behavior
augroup MiniStatusline
  au!
  au WinEnter,BufEnter * setlocal statusline=%!MiniStatuslineActive()
  au WinLeave,BufLeave * setlocal statusline=%!MiniStatuslineInactive()
augroup END

" MiniStatusline colors (Nord)
hi MiniStatuslineModeNormal  guibg=#3B4252 guifg=#81A1C1 gui=bold ctermbg=236 ctermfg=110
hi MiniStatuslineModeInsert  guibg=#3B4252 guifg=#88C0D0 gui=bold ctermbg=236 ctermfg=117
hi MiniStatuslineModeVisual  guibg=#3B4252 guifg=#A3BE8C gui=bold ctermbg=236 ctermfg=108
hi MiniStatuslineModeReplace guibg=#3B4252 guifg=#BF616A gui=bold ctermbg=236 ctermfg=167
hi MiniStatuslineModeCommand guibg=#3B4252 guifg=#EBCB8B gui=bold ctermbg=236 ctermfg=223
hi MiniStatuslineModeOther   guibg=#3B4252 guifg=#5E81AC gui=bold ctermbg=236 ctermfg=110
hi MiniStatuslineInactive    guibg=#2E3440 guifg=#616E88 ctermbg=235 ctermfg=59
hi MiniStatuslineFilename    guibg=#3B4252 guifg=#ECEFF4 gui=bold ctermbg=236 ctermfg=231
hi MiniStatuslineFileinfo    guibg=#3B4252 guifg=#81A1C1 ctermbg=236 ctermfg=110

" High-level definition of statusline content
function MiniStatuslineActive()
  let l:mode_info = s:statusline_modes[mode()]

  let l:mode = s:SectionMode(l:mode_info, 120)
  let l:spell = s:SectionSpell(120)
  let l:wrap = s:SectionWrap()
  " Diagnostics section is missing as this is a script for Vim
  let l:filename = s:SectionFilename(140)
  let l:zoomed = s:SectionZoom()
  let l:fileinfo = s:SectionFileinfo(120)
  let l:location = s:SectionLocation()

  return s:CombineSections([
    \ {'string': l:mode,     'hl': l:mode_info['hl']},
    \ {'string': l:spell,    'hl': v:null},
    \ {'string': l:wrap,     'hl': v:null},
    \ '%<',
    \ {'string': l:filename, 'hl': '%#MiniStatuslineFilename#'},
    \ {'string': l:zoomed,   'hl': '%#MiniStatuslineFilename#'},
    \ '%=',
    \ {'string': l:fileinfo, 'hl': '%#MiniStatuslineFileinfo#'},
    \ {'string': l:location, 'hl': l:mode_info['hl']},
    \ ])
endfunction

function MiniStatuslineInactive()
  return '%#MiniStatuslineInactive#%F%='
endfunction

" Mode
let s:statusline_modes = {
  \ 'n'     : {'long': 'NORMAL'  , 'short': 'N'  , 'hl': '%#MiniStatuslineModeNormal#'},
  \ 'v'     : {'long': 'VISUAL'  , 'short': 'V'  , 'hl': '%#MiniStatuslineModeVisual#'},
  \ 'V'     : {'long': 'V-LINE'  , 'short': 'V-L', 'hl': '%#MiniStatuslineModeVisual#'},
  \ "\<C-V>": {'long': 'V-BLOCK' , 'short': 'V-B', 'hl': '%#MiniStatuslineModeVisual#'},
  \ 's'     : {'long': 'SELECT'  , 'short': 'S'  , 'hl': '%#MiniStatuslineModeVisual#'},
  \ 'S'     : {'long': 'S-LINE'  , 'short': 'S-L', 'hl': '%#MiniStatuslineModeVisual#'},
  \ "\<C-S>": {'long': 'S-BLOCK' , 'short': 'S-B', 'hl': '%#MiniStatuslineModeVisual#'},
  \ 'i'     : {'long': 'INSERT'  , 'short': 'I'  , 'hl': '%#MiniStatuslineModeInsert#'},
  \ 'R'     : {'long': 'REPLACE' , 'short': 'R'  , 'hl': '%#MiniStatuslineModeReplace#'},
  \ 'c'     : {'long': 'COMMAND' , 'short': 'C'  , 'hl': '%#MiniStatuslineModeCommand#'},
  \ 'r'     : {'long': 'PROMPT'  , 'short': 'P'  , 'hl': '%#MiniStatuslineModeOther#'},
  \ '!'     : {'long': 'SHELL'   , 'short': 'Sh' , 'hl': '%#MiniStatuslineModeOther#'},
  \ 't'     : {'long': 'TERMINAL', 'short': 'T'  , 'hl': '%#MiniStatuslineModeOther#'},
  \ }

function s:SectionMode(mode_info, trunc_width)
  return s:IsTruncated(a:trunc_width) ?
    \ a:mode_info['short'] :
    \ a:mode_info['long']
endfunction

" Spell
function s:SectionSpell(trunc_width)
  if &spell == 0 | return '' | endif

  if s:IsTruncated(a:trunc_width) | return 'SPELL' | endif

  return printf('SPELL(%s)', &spelllang)
endfunction

" Wrap
function s:SectionWrap()
  if &wrap == 0 | return '' | endif

  return 'WRAP'
endfunction

" File name
function s:SectionFilename(trunc_width)
  " In terminal always use plain name
  if &buftype == 'terminal'
    return '%t'
  " File name with 'truncate', 'modified', 'readonly' flags
  elseif s:IsTruncated(a:trunc_width)
    " Use relative path if truncated
    return '%f%m%r'
  else
    " Use fullpath if not truncated
    return '%F%m%r'
  endif
endfunction

" Zoom status
function s:SectionZoom()
    if exists("t:zoomed")
        return '(+)'
    else
        return ''
endfunction

function s:SectionFileinfo(trunc_width)
  let l:filetype = &filetype

  " Don't show anything if can't detect file type or not inside a 'normal
  " buffer'
  if ((l:filetype == '') || s:IsntNormalBuffer()) | return '' | endif

  " Construct output string if truncated
  if s:IsTruncated(a:trunc_width) | return l:filetype | endif

  " Construct output string with extra file info
  let l:encoding = &fileencoding
  if l:encoding == '' | let l:encoding = &encoding | endif
  let l:format = &fileformat

  return printf('%s %s[%s]', l:filetype, l:encoding, l:format)
endfunction

" Location inside buffer
function s:SectionLocation()
  " Use virtual column number to allow update when paste last column
  return '%l:%2v'
endfunction
" }}}

" ------------------------------- PLUGINS --------------------------------------

" ----
" Rust
" ----
"packadd termdebug
"let g:termdebugger = "rust-gdb"
"let g:termdebug_wide = 1

" ----------
" Cscope.vim
" ----------
" Only enable if Vim was compiled with cscope support.
if has("cscope")
  " use both cscope and ctag for CTRL-]
  set cscopetag
  " check cscope for definition before checking ctags? 0 = ctags first
  set csto=0

  " Add database if found in cwd or via $CSCOPE_DB
  if filereadable("cscope.out")
    cs add cscope.out
  elseif exists("$CSCOPE_DB") && $CSCOPE_DB != ""
    cs add $CSCOPE_DB
  endif

  set nocscopeverbose

  " direct jump results (current window)
  nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
  nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
  nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
  nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
  nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
  nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
  nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
  nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>

  " horizontal split (CTRL-@ is CTRL-Space in many terminals)
  nmap <C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>
  nmap <C-@>g :scs find g <C-R>=expand("<cword>")<CR><CR>
  nmap <C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>
  nmap <C-@>t :scs find t <C-R>=expand("<cword>")<CR><CR>
  nmap <C-@>e :scs find e <C-R>=expand("<cword>")<CR><CR>
  nmap <C-@>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
  nmap <C-@>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
  nmap <C-@>d :scs find d <C-R>=expand("<cword>")<CR><CR>

  " vertical split (double CTRL-@)
  nmap <C-@><C-@>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
  nmap <C-@><C-@>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
  nmap <C-@><C-@>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
  nmap <C-@><C-@>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
  nmap <C-@><C-@>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
  nmap <C-@><C-@>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
  nmap <C-@><C-@>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
  nmap <C-@><C-@>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>

  " CTRL-T : jump back
endif


" ------------------------------
" christoomey/vim-tmux-navigator
" ------------------------------

" Maps <C-h/j/k/l> to switch vim splits in the given direction. If there are no more windows in that direction, forwards the operation to tmux.
" Additionally, <C-\> toggles between last active vim splits/tmux panes.

if exists("g:loaded_tmux_navigator") || &cp || v:version < 700
  finish
endif
let g:loaded_tmux_navigator = 1

function! s:VimNavigate(direction)
  try
    execute 'wincmd ' . a:direction
  catch
    echohl ErrorMsg | echo 'E11: Invalid in command-line window; <CR> executes, CTRL-C quits: wincmd k' | echohl None
  endtry
endfunction

if !get(g:, 'tmux_navigator_no_mappings', 0)
  nnoremap <silent> <c-h> :<C-U>TmuxNavigateLeft<cr>
  nnoremap <silent> <c-j> :<C-U>TmuxNavigateDown<cr>
  nnoremap <silent> <c-k> :<C-U>TmuxNavigateUp<cr>
  nnoremap <silent> <c-l> :<C-U>TmuxNavigateRight<cr>
  nnoremap <silent> <c-\> :<C-U>TmuxNavigatePrevious<cr>

  if !empty($TMUX)
    function! IsFZF()
      return &ft == 'fzf'
    endfunction
    tnoremap <expr> <silent> <C-h> IsFZF() ? "\<C-h>" : "\<C-w>:\<C-U> TmuxNavigateLeft\<cr>"
    tnoremap <expr> <silent> <C-j> IsFZF() ? "\<C-j>" : "\<C-w>:\<C-U> TmuxNavigateDown\<cr>"
    tnoremap <expr> <silent> <C-k> IsFZF() ? "\<C-k>" : "\<C-w>:\<C-U> TmuxNavigateUp\<cr>"
    tnoremap <expr> <silent> <C-l> IsFZF() ? "\<C-l>" : "\<C-w>:\<C-U> TmuxNavigateRight\<cr>"
  endif

  if !get(g:, 'tmux_navigator_disable_netrw_workaround', 0)
    if !exists('g:Netrw_UserMaps')
      let g:Netrw_UserMaps = [['<C-l>', '<C-U>TmuxNavigateRight<cr>']]
    else
      echohl ErrorMsg | echo 'vim-tmux-navigator conflicts with netrw <C-l> mapping. See https://github.com/christoomey/vim-tmux-navigator#netrw or add `let g:tmux_navigator_disable_netrw_workaround = 1` to suppress this warning.' | echohl None
    endif
  endif
endif

if empty($TMUX)
  command! TmuxNavigateLeft call s:VimNavigate('h')
  command! TmuxNavigateDown call s:VimNavigate('j')
  command! TmuxNavigateUp call s:VimNavigate('k')
  command! TmuxNavigateRight call s:VimNavigate('l')
  command! TmuxNavigatePrevious call s:VimNavigate('p')
  finish
endif

command! TmuxNavigateLeft call s:TmuxAwareNavigate('h')
command! TmuxNavigateDown call s:TmuxAwareNavigate('j')
command! TmuxNavigateUp call s:TmuxAwareNavigate('k')
command! TmuxNavigateRight call s:TmuxAwareNavigate('l')
command! TmuxNavigatePrevious call s:TmuxAwareNavigate('p')

if !exists("g:tmux_navigator_save_on_switch")
  let g:tmux_navigator_save_on_switch = 0
endif

if !exists("g:tmux_navigator_disable_when_zoomed")
  let g:tmux_navigator_disable_when_zoomed = 0
endif

if !exists("g:tmux_navigator_preserve_zoom")
  let g:tmux_navigator_preserve_zoom = 0
endif

if !exists("g:tmux_navigator_no_wrap")
  let g:tmux_navigator_no_wrap = 0
endif

let s:pane_position_from_direction = {'h': 'left', 'j': 'bottom', 'k': 'top', 'l': 'right'}

function! s:TmuxOrTmateExecutable()
  return (match($TMUX, 'tmate') != -1 ? 'tmate' : 'tmux')
endfunction

function! s:TmuxVimPaneIsZoomed()
  return s:TmuxCommand("display-message -p '#{window_zoomed_flag}'") == 1
endfunction

function! s:TmuxSocket()
  " The socket path is the first value in the comma-separated list of $TMUX.
  return split($TMUX, ',')[0]
endfunction

function! s:TmuxCommand(args)
  let cmd = s:TmuxOrTmateExecutable() . ' -S ' . s:TmuxSocket() . ' ' . a:args
  let l:x=&shellcmdflag
  let &shellcmdflag='-c'
  let retval=system(cmd)
  let &shellcmdflag=l:x
  return retval
endfunction

function! s:TmuxNavigatorProcessList()
  echo s:TmuxCommand("run-shell 'ps -o state= -o comm= -t ''''#{pane_tty}'''''")
endfunction
command! TmuxNavigatorProcessList call s:TmuxNavigatorProcessList()

let s:tmux_is_last_pane = 0
augroup tmux_navigator
  au!
  autocmd WinEnter * let s:tmux_is_last_pane = 0
augroup END

function! s:NeedsVitalityRedraw()
  return exists('g:loaded_vitality') && v:version < 704 && !has("patch481")
endfunction

function! s:ShouldForwardNavigationBackToTmux(tmux_last_pane, at_tab_page_edge)
  if g:tmux_navigator_disable_when_zoomed && s:TmuxVimPaneIsZoomed()
    return 0
  endif
  return a:tmux_last_pane || a:at_tab_page_edge
endfunction


function! s:TmuxAwareNavigate(direction)
  let nr = winnr()
  let tmux_last_pane = (a:direction == 'p' && s:tmux_is_last_pane)
  if !tmux_last_pane
    call s:VimNavigate(a:direction)
  endif
  let at_tab_page_edge = (nr == winnr())
  " Forward the switch panes command to tmux if:
  " a) we're toggling between the last tmux pane;
  " b) we tried switching windows in vim but it didn't have effect.
  if s:ShouldForwardNavigationBackToTmux(tmux_last_pane, at_tab_page_edge)
    if g:tmux_navigator_save_on_switch == 1
      try
        update " save the active buffer. See :help update
      catch /^Vim\%((\a\+)\)\=:E32/ " catches the no file name error
      endtry
    elseif g:tmux_navigator_save_on_switch == 2
      try
        wall " save all the buffers. See :help wall
      catch /^Vim\%((\a\+)\)\=:E141/ " catches the no file name error
      endtry
    endif
    let args = 'select-pane -t ' . shellescape($TMUX_PANE) . ' -' . tr(a:direction, 'phjkl', 'lLDUR')
    if g:tmux_navigator_preserve_zoom == 1
      let l:args .= ' -Z'
    endif
    if g:tmux_navigator_no_wrap == 1 && a:direction != 'p'
      let args = 'if -F "#{pane_at_' . s:pane_position_from_direction[a:direction] . '}" "" "' . args . '"'
    endif
    silent call s:TmuxCommand(args)
    if s:NeedsVitalityRedraw()
      redraw!
    endif
    let s:tmux_is_last_pane = 1
  else
    let s:tmux_is_last_pane = 0
  endif
endfunction
