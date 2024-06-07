

"=== Custom/Old plugins
source ~/.vim/plugin/cscope_maps.vim

"=== Enable lightline
set laststatus=2

"=== ALE/Rust config
let g:ale_history_log_output = 1

" Auto detect rust files
autocmd BufNewFile,BufRead *.rs set filetype=rust
" Setup Code completion
set omnifunc=ale#completion#OmniFunc
set completeopt=menu,menuone,preview,noselect,noinsert
let g:ale_completion_enabled = 1
let g:ale_completion_autoimport = 1

" Gutters always visible, do not move text area
let g:ale_sign_column_always = 1

" Check on save
let g:ale_fix_on_save = 1

" Custom printed signs
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
highlight ALEErrorSign ctermbg=NONE ctermfg=red
highlight ALEWarningSign ctermbg=NONE ctermfg=yellow
highlight ALEWarning ctermbg=NONE  ctermfg=238


" Define fixers for auto formatting
let g:ale_fixers = {
    \ '*': ['remove_trailing_lines', 'trim_whitespace'],
    \ 'rust': ['rustfmt'],
\}

" Required, explicitly enable Rust LS
let g:ale_linters = {
    \  'rust': ['analyzer'],
\}
" WARNING: Ensure rust-analyzer is installed: $ rust-analyzer --version

"=== Vim Plug Manager
call plug#begin()
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Vim (Windows): '~/vimfiles/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'

" Make sure you use single quotes

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'preservim/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'itchyny/lightline.vim'
Plug 'rust-lang/rust.vim'
Plug 'dense-analysis/ale'

" Initialize plugin system
" - Automatically executes `filetype plugin indent on` and `syntax enable`.
call plug#end()
" You can revert the settings after the call like so:
"   filetype indent off   " Disable file-type-specific indentation
"   syntax off            " Disable syntax highlighting

"=== Custom shortcuts
nmap <silent> <C-a>g :ALEGoToDefinition<CR>
nmap <silent> <C-a>s :ALEFindReferences<CR>
" Navigate through errors
nmap <silent> <C-a>p <Plug>(ale_previous_wrap)
nmap <silent> <C-a>n <Plug>(ale_next_wrap)

" Cycle through completion with TABS
inoremap <silent><expr><TAB>
    \ pumvisible() ? "\<C-n>" : "\<TAB>"
