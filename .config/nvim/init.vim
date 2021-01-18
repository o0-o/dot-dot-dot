" XDG Compliance -------------------------------------------------------
set directory=$XDG_CACHE_HOME/nvim,~/,/tmp
set backupdir=$XDG_CACHE_HOME/nvim,~/,/tmp
set viminfo+=n$XDG_CACHE_HOME/nvim/viminfo

" Plugins via junegunn/vim-plug ----------------------------------------
call plug#begin(system('printf "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/junegunn_vim-plugged"'))
  Plug 'tpope/vim-sensible'           " defaults
  Plug 'tpope/vim-surround'           " manipulate quotes, brackets, tags, etc
  Plug 'tpope/vim-repeat'             " extend . repeat functionality to plugins
  Plug 'tpope/vim-sleuth'             " auto-detect indentation
  Plug 'ervandew/supertab'            " tab completion
  Plug 'darfink/vim-plist'            " plist encoding support
  Plug 'vim-airline/vim-airline'      " interface theming
  Plug 'dracula/vim',{'as':'dracula'} " dracula theme
  Plug 'ap/vim-css-color'             " overlay text representations of colors with the color
call plug#end()

" Basics ---------------------------------------------------------------
set nocompatible    " don't try to be compatible with legacy vi
set encoding=utf-8
filetype plugin on  " detect file types

" Formatting -----------------------------------------------------------
syntax on                   " enable syntax highlighting
if exists('+termguicolors') " use 24-bit color if possible
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif
colorscheme dracula         " use dracula theme
"dracula overrides
hi! link Search DraculaBgLighter
hi! link IncSearch DraculaOrangeInverse
"indenting defaults (does not override vim-sleuth's indenting detection)
if get(g:, '_has_set_default_indent_settings', 0) == 0
  set expandtab     " convert tabs to spaces
  set tabstop=2     " 2-space \t
  set softtabstop=2 " 2-space tab
  set shiftwidth=2  " 2-space indent
  let g:_has_set_default_indent_settings=1
endif
set list lcs=space:·,trail:·,tab:»· " whitespace indicators

" Clipboard ------------------------------------------------------------
set clipboard+=unnamedplus  " use system clipboard
set go+=a                   " automatically copy visual selection to clipboard

" Interface ------------------------------------------------------------
set mouse=a               " enable mouse in all modes
set number relativenumber " relative line numbers and current line number
let &colorcolumn="73,80"            " pep8 line length indicators
"status line
set laststatus=2          " always show the status line
set noshowmode  " airline handles this for us
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#formatter='unique_tail_improved'
let g:airline_symbols_ascii=1
let g:airline_section_c="%<%m %#__accent_red#%{airline#util#wrap(airline#parts#readonly(),0)}%#__restore__#%#__accent_bold#%#__restore__#"

" Behaviors ------------------------------------------------------------
set iskeyword-=_                " count underscore as word separator
set wildmode=longest,list,full  " autocompletion
"supertab tab completion
let g:SuperTabMappingForward = '<s-tab>'
let g:SuperTabMappingBackward = '<s-c-tab>'
"disable automatic commenting on newline
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
set splitbelow splitright " split open at the bottom and right
autocmd BufWritePre * %s/\s\+$//e   " delete trailing whitespace on save
autocmd BufWritePre * %s/\n\+\%$//e
