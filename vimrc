""" ~/.vimrc: Runtime configuration for `vim`

"" Encoding and runtimepath
set encoding=utf-8 " Always use UTF-8 encoding

if has('win32')
  set runtimepath^=~/.vim
endif

call plug#begin('~/.vim/plug')
Plug 'chriskempson/base16-vim'
Plug 'deris/vim-shot-f'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf.vim'
Plug 'ktchen14/cscope-auto'
Plug 'ktchen14/status-symbol'
Plug 'majutsushi/tagbar'
Plug 'sheerun/vim-polyglot'
Plug 'tommcdo/vim-lion'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'

if executable('editorconfig')
  Plug 'editorconfig/editorconfig-vim'
endif

Plug 'vim-scripts/syntaxm4.vim'
call plug#end()

"" General Configuration

" Global options
set nocompatible
filetype plugin indent on
syntax enable

" Indentation options
set autoindent
set backspace=indent,eol,start
set expandtab
set shiftround
set shiftwidth=2
set smarttab
set softtabstop=2

" Display options
set display=lastline
set listchars=eol:¶,tab:→·,nbsp:·,trail:·,extends:›,precedes:‹
set number
set numberwidth=4
set scrolloff=1
set sidescrolloff=4
set splitbelow
set splitright
set visualbell t_vb=

" Behavior options
set autoread
if has('unnamedplus')
  set clipboard=unnamedplus
else
  set clipboard=unnamed
endif
set complete-=i
set nojoinspaces
set nrformats-=octal
set hidden
set history=2000
set undolevels=2000
set modelines=2
set wildmenu
set wildmode=longest:full

" Search options
" Keep hlsearch status on reload
if exists('v:hlsearch')
  let hlsearch=v:hlsearch
endif
set hlsearch
if exists('v:hlsearch')
  let v:hlsearch=hlsearch
endif
set incsearch

" Text wrap options
" Prefix broken lines with ↪
if exists('&breakindent')
  set breakindent
  set breakindentopt=shift:-2
endif
set showbreak=↪\ 

" Folding options
set foldopen-=block

" See :help last-position-jump
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" Allow bright without bold
if &t_Co == 8 && $TERM !~# '^linux'
  set t_Co=16
endif
set background=dark
silent! colorscheme base16-ocean

"" Helper Functions

function! CnoreabbrevHead(from, to) abort
  exec 'cnoreabbrev <expr> ' . a:from . ' '
        \ 'getcmdtype() . getcmdline() ==# ":' . a:from . '" ? '
        \ '"' . a:to . '" : "' . a:from . '"'
endfunction

"" Mappings and Abbreviations
let mapleader = "\<Space>"

nnoremap <CR> :

nnoremap <silent><BS> :nohlsearch<CR>
nnoremap Y y$
nnoremap U <C-r>
noremap Q @

if exists(':tnoremap')
  tnoremap <Esc> <C-\><C-n>
endif

cnoremap <C-a> <Home>
cnoremap <C-e> <End>

" Map window motions to g prefixed lowercased ones
noremap gh H
noremap gl L
noremap gm M

" H and L are easier than ^ and $
noremap <expr> H (v:count == 0 ? '^' : '|')
noremap gH g^
noremap L $
noremap gL g$

" Map M to ' (' is the opposite of m)
noremap M '

nnoremap <C-h> :bp<CR>
nnoremap <C-l> :bn<CR>

" Page Up and Page Down
nnoremap <C-j> <C-d>
nnoremap <C-k> <C-u>

" Map s to window navigation prefix
noremap s <C-w>
noremap S <NOP>

nnoremap <Tab> za

nnoremap <silent> <Leader>rr :source $MYVIMRC<CR>
nnoremap <silent> <Leader>re :edit $MYVIMRC<CR>

nnoremap ]] ][
nnoremap ][ ]]

nnoremap <silent> [b :<C-u>exec '' . (v:count ? v:count : '') . 'bprev'<CR>
nnoremap <silent> [B :<C-u>exec '' . (v:count ? v:count : '') . 'bfirst'<CR>
nnoremap <silent> ]b :<C-u>exec '' . (v:count ? v:count : '') . 'bnext'<CR>
nnoremap <silent> ]B :<C-u>exec '' . (v:count ? v:count : '') . 'blast'<CR>

nnoremap <silent> <C-P> :FZF!<CR>

call CnoreabbrevHead('lgrep', 'silent lgrep')
call CnoreabbrevHead('lgr', 'silent lgrep')
call CnoreabbrevHead('grep', 'silent grep')
call CnoreabbrevHead('gr', 'silent grep')
call CnoreabbrevHead('lgrepadd', 'silent lgrepadd')
call CnoreabbrevHead('lgrepa', 'silent lgrepadd')
call CnoreabbrevHead('grepadd', 'silent grepadd')
call CnoreabbrevHead('grepa', 'silent grepadd')

" Find this C symbol
nnoremap <Leader>cs :cs find s 
nnoremap <Leader>cS :cs find s <C-r>=expand("<cword>")<CR><CR>
" Find this global definition
nnoremap <Leader>cg :cs find g 
nnoremap <Leader>cG :cs find g <C-r>=expand("<cword>")<CR><CR>
" Find functions called by this function
nnoremap <Leader>cd :cs find d 
nnoremap <Leader>cD :cs find d <C-r>=expand("<cword>")<CR><CR>
" Find functions calling this function
nnoremap <Leader>cc :cs find c 
nnoremap <Leader>cC :cs find c <C-r>=expand("<cword>")<CR><CR>
" Find this text string
nnoremap <Leader>ct :cs find t 
nnoremap <Leader>cT :cs find t <C-r>=expand("<cword>")<CR><CR>
" Find this egrep pattern
nnoremap <Leader>ce :cs find e 
nnoremap <Leader>cE :cs find e <C-r>=expand("<cword>")<CR><CR>
" Find this file
nnoremap <Leader>cf :cs find f 
nnoremap <Leader>cF :cs find f <C-r>=expand("<cword>")<CR><CR>
" Find files #including this file
nnoremap <Leader>ci :cs find i 
nnoremap <Leader>cI :cs find i <C-r>=expand("<cword>")<CR><CR>
" Find assignments to this symbol
nnoremap <Leader>ca :cs find a 
nnoremap <Leader>cA :cs find a <C-r>=expand("<cword>")<CR><CR>

"" Quickfix List

if executable('ag')
  " When ag --vimgrep is used as the grepprg and :grep is issued without
  " arguments, ag outputs 'ERR: What do you want to search for?', breaking the
  " display until a :redraw! is issued. The --silent helps avoid this.
  set grepprg=ag\ --vimgrep\ --silent\ $* grepformat=%f:%l:%c:%m
endif

function! ToggleQuickfixList()
  redir => output
  " Find all active [Quickfix List] buffers
  silent! filter /^\[Quickfix List\]$/ ls a
  redir END
  let bufnr = matchstr(output, '\d\+')

  if !empty(bufnr) && bufwinnr(str2nr(bufnr)) != -1
    cclose
    return
  endif

  let winnr = winnr()
  botright copen
  if winnr() != winnr
    wincmd p
  endif
endfunction
nnoremap <silent> <Leader>q :call ToggleQuickfixList()<CR>

nnoremap <silent> [q :<C-u>exec '' . (v:count ? v:count : '') . 'cprev'<CR>zv
nnoremap <silent> [Q :<C-u>exec '' . (v:count ? v:count : '') . 'cfirst'<CR>zv
nnoremap <silent> ]q :<C-u>exec '' . (v:count ? v:count : '') . 'cnext'<CR>zv
nnoremap <silent> ]Q :<C-u>exec '' . (v:count ? v:count : '') . 'clast'<CR>zv

nnoremap <silent> [l :<C-u>exec '' . (v:count ? v:count : '') . 'lprev'<CR>zv
nnoremap <silent> [L :<C-u>exec '' . (v:count ? v:count : '') . 'lfirst'<CR>zv
nnoremap <silent> ]l :<C-u>exec '' . (v:count ? v:count : '') . 'lnext'<CR>zv
nnoremap <silent> ]L :<C-u>exec '' . (v:count ? v:count : '') . 'llast'<CR>zv

" Map gs to switch between source and header file
function! FileHeaderSource()
  let extension = expand('%:e')
  let name = expand('%:r')
  if extension == 'h' && filereadable(name . '.c')
    exec ':e ' . name . '.c'
    return
  endif
  if extension == 'c' && filereadable(name . '.h')
    exec ':e ' . name . '.h'
    return
  endif
endfunction
nnoremap <silent> gs :call FileHeaderSource()<CR>

"" Filetype Configuration
autocmd FileType python setlocal sw=4 sts=4

" Open help window splitright with width 78
autocmd FileType help set bufhidden=unload | wincmd L | vertical resize 78

autocmd QuickFixCmdPost cscope botright copen

"" Plugin Configuration

" vim-plug

" Set the plug window height based on the number of plugs
let g:plug_window = 'botright ' . (len(g:plugs) + 4) . 'new'

" cscope-auto

set cscopequickfix=s-,c-,d-,i-,t-,e-
silent! set cscopequickfix+=a-
let g:cscope_auto_database_name = '.cscope'

" editorconfig

if executable('editorconfig')
  let g:EditorConfig_core_mode = 'external_command'
endif

" fzf

if isdirectory('/usr/local/opt/fzf')
  set runtimepath^=/usr/local/opt/fzf
endif
autocmd FileType fzf silent! tunmap <Esc>
let $FZF_DEFAULT_OPTS = '--inline-info'

" lightline

let g:lightline = { 'colorscheme': 'Tomorrow_Night', 'enable': { 'tabline': 0 } }

set noshowmode
set laststatus=2

" vim-lion

let g:lion_squeeze_spaces = 1
let g:lion_map_left = 'c<'
let g:lion_map_right = 'c>'

" tagbar

let g:tagbar_indent = 0
let g:tagbar_sort = 0
nmap <Leader>tt :TagbarToggle<CR>

"" Folding Expression and Text

" Ensure that VimrcFoldExpr is callable from this modeline
if exists('&modelineexpr') | set modelineexpr | endif

function! VimrcFoldExpr()
  " Don't fold the header even though it starts with """
  if v:lnum == 1 | return 0 | end

  " Get the line without leading and trailing whitespace
  let line = matchstr(getline(v:lnum), '^\s*\zs.\{-}\ze\s*$')

  if empty(line)
    return -1
  elseif line =~ '^call plug#begin'
    return '>1'
  elseif line =~ '^call plug#end'
    return '<1'
  endif

  " Get the number of leading " characters
  let length = len(matchstr(line, '^"\{2,}'))
  return length > 1 ? '>1' : '='
endfunction

function! VimrcFoldText()
  let name = matchstr(getline(v:foldstart),
        \ '^\s*"*\s*\zs.\{-}\ze\s*$')
  return '+' . v:folddashes . ' ' . name . ' '
endfunction

" vim: set fdm=expr fde=VimrcFoldExpr() fdt=VimrcFoldText():
