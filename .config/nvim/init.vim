" xdg compliance
set directory=$XDG_CACHE_HOME/nvim,~/,/tmp
set backupdir=$XDG_CACHE_HOME/nvim,~/,/tmp
set viminfo+=n$XDG_CACHE_HOME/nvim/viminfo

" nvim config, mostly taken from lukesmithxyz/voidrice

" junegunn/vim-plug
call plug#begin(system('printf "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/junegunn_vim-plugged"'))
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'ciaranm/detectindent'
Plug 'preservim/nerdtree'
Plug 'bling/vim-bufferline'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ap/vim-css-color'
call plug#end()

" basics
set bg=dark
set go=a
set mouse=a
set clipboard+=unnamedplus
set nocompatible
filetype plugin on
syntax on
set encoding=utf-8
set number relativenumber
set expandtab
set shiftwidth=2
set softtabstop=2

" autocompletion
set wildmode=longest,list,full

" disable automatic commenting on newline
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" split open at the bottom and right
set splitbelow splitright

" preservim/nerdtree
map <leader>n :NERDTreeToggle<CR>
autocmd bufenter * if (winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree()) | q | endif
if has('nvim')
  let NERDTreeBookmarksFile = stdpath('data') . '/NERDTreeBookmarks'
else
  let NERDTreeBookmarksFile = '~/.vim' . '/NERDTreeBookmarks'
endif

" delete trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritePre * %s/\n\+\%$//e

" indent line
set list lcs=space:·,trail:·,tab:»·
highlight NonText ctermfg=239

" search highlight
set hlsearch
highlight Search cterm=NONE ctermfg=NONE ctermbg=239
highlight IncSearch cterm=NONE ctermfg=NONE ctermbg=239

" negative space and length warning
let &colorcolumn="73,".join(range(80,999),",")
highlight Normal ctermbg=235
highlight colorcolumn ctermbg=234
highlight EndOfBuffer ctermbg=234 ctermfg=234

" airline
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline_powerline_fonts = 1
let g:airline_theme='simple'
