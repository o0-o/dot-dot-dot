" xdg compliance
set directory=$XDG_CACHE_HOME/nvim,~/,/tmp
set backupdir=$XDG_CACHE_HOME/nvim,~/,/tmp
set viminfo+=n$XDG_CACHE_HOME/nvim/viminfo

" junegunn/vim-plug
call plug#begin(system('printf "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/junegunn_vim-plugged"'))
  Plug 'tpope/vim-sensible'
" Plug 'tpope/vim-surround'
" Plug 'tpope/vim-repeat'
" Plug 'tpope/vim-fugitive'
" Plug 'tpope/vim-obsession'
" Plug 'tpope/vim-commentary'
 Plug 'tpope/vim-sleuth'
" Plug 'ciaranm/detectindent'
" Plug 'sheerun/vim-polyglot'
" Plug 'preservim/nerdtree'
" Plug 'bling/vim-bufferline'
  Plug 'ervandew/supertab'
  Plug 'darfink/vim-plist'
" Plug 'itchyny/lightline.vim'
  Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
" Plug 'arcticicestudio/nord-vim'
  Plug 'dracula/vim',{'as':'dracula'}
  Plug 'ap/vim-css-color'
call plug#end()

" basics
"set bg=dark
set go=a
set mouse=a
set clipboard+=unnamedplus
set nocompatible
filetype plugin on
syntax on
set encoding=utf-8
set number relativenumber
set iskeyword-=_
" Indenting defaults (does not override vim-sleuth's indenting detection)
if get(g:, '_has_set_default_indent_settings', 0) == 0
  " Set the indenting level to 2 spaces for the following file types.
  set expandtab
  set tabstop=2
  set shiftwidth=2
  let g:_has_set_default_indent_settings = 1
endif

" Use 24-bit color if possible
if exists('+termguicolors')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif
colorscheme dracula
highlight Comment cterm=italic gui=italic
set noshowmode

set laststatus=2

" autocompletion
set wildmode=longest,list,full

" disable automatic commenting on newline
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" split open at the bottom and right
set splitbelow splitright

" preservim/nerdtree
" map <leader>n :NERDTreeToggle<CR>
" autocmd bufenter * if (winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree()) | q | endif
" if has('nvim')
"   let NERDTreeBookmarksFile = stdpath('data') . '/NERDTreeBookmarks'
" else
"   let NERDTreeBookmarksFile = '~/.vim' . '/NERDTreeBookmarks'
" endif

" delete trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritePre * %s/\n\+\%$//e

" indent line
set list lcs=space:·,trail:·,tab:»·

" search highlight
set hlsearch
" highlight Search cterm=NONE ctermfg=NONE ctermbg=1
" highlight IncSearch cterm=NONE ctermfg=NONE ctermbg=1

" negative space and length warning
let &colorcolumn="73,80"
"highlight Normal ctermbg=235
"highlight colorcolumn ctermbg=234
"highlight EndOfBuffer ctermbg=234 ctermfg=234

" airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline_symbols_ascii = 1
let g:airline_section_c = "%<%m %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#%#__accent_bold#%#__restore__#"
" let g:airline_powerline_fonts = 1
" let g:airline_theme='simple'

" supertab
 let g:SuperTabMappingForward = '<s-tab>'
 let g:SuperTabMappingBackward = '<s-c-tab>'
