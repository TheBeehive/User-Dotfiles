""" ~/.vimrc: Runtime configuration for `vim`

"" Encoding and runtimepath
set encoding=utf-8 " Always use UTF-8 encoding

if has('win32')
  set runtimepath^=~/.vim
endif

call plug#begin('~/.vim/plug')

Plug 'itchyny/lightline.vim'
Plug 'chriskempson/base16-vim'
Plug 'tpope/vim-commentary'
Plug 'ktchen14/cscope-auto'
Plug 'tpope/vim-fugitive'
Plug 'tommcdo/vim-lion'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-repeat'
Plug 'deris/vim-shot-f'
Plug 'tpope/vim-surround'
Plug 'majutsushi/tagbar'
Plug 'raimondi/delimitmate'

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
set breakindent
set breakindentopt=shift:-2
set showbreak=↪\ 
set scrolloff=1
set sidescrolloff=4
set hlsearch
set incsearch
set number
set numberwidth=4
set visualbell t_vb=
set splitbelow
set splitright

" Behavior options
set autoread
set clipboard=unnamedplus
set complete-=i
set nrformats-=octal
set hidden
set history=2000
set undolevels=2000
set modelines=2
set wildmenu
set wildmode=longest:full

" Folding options
set foldopen-=block

" Allow bright without bold
if &t_Co == 8 && $TERM !~# '^linux'
  set t_Co=16
endif
set background=dark
silent! colorscheme base16-ocean

"" Mappings and Abbreviations
let mapleader = "\<Space>"

noremap <CR> :

nnoremap <silent><BS> :nohlsearch<CR>
nnoremap Y y$
nnoremap U <C-r>
noremap Q @

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
nnoremap <C-j> <C-d>
nnoremap <C-k> <C-u>

" Map s to window navigation prefix
noremap s <C-w>
noremap S <NOP>

nnoremap <Tab> za

" Search highlighting is reactivated whenever hlsearch is set (in $MYVIMRC)
nnoremap <silent> <Leader>rr :source $MYVIMRC | nohlsearch<CR>
nnoremap <silent> <Leader>re :e $MYVIMRC<CR>

nnoremap <silent> [b :<C-u>exec '' . (v:count ? v:count : '') . 'bprev'<CR>
nnoremap <silent> [B :<C-u>exec '' . (v:count ? v:count : '') . 'bfirst'<CR>
nnoremap <silent> ]b :<C-u>exec '' . (v:count ? v:count : '') . 'bnext'<CR>
nnoremap <silent> ]B :<C-u>exec '' . (v:count ? v:count : '') . 'blast'<CR>

"" Quickfix List

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
  copen
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

"" Plugin Configuration

" vim-plug

" Set the plug window height based on the number of plugs
let g:plug_window = 'botright ' . (len(g:plugs) + 4) . 'new'

" cscope-auto

let g:cscope_auto_database_name = '.cscope'
set cscopequickfix=s-,c-,d-,i-,t-,e-,a-

" lightline

let g:lightline = { 'colorscheme': 'Tomorrow_Night' }

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
  return length > 1 ? '>' . (3 - length) : '='
endfunction

function! VimrcFoldText()
  let name = matchstr(getline(v:foldstart),
        \ '^\s*"*\s*\zs.\{-}\ze\s*$')
  return '+' . v:folddashes . ' ' . name . ' '
endfunction

" vim: set fdm=expr fde=VimrcFoldExpr() fdt=VimrcFoldText():
