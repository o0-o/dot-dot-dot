" vim: ts=2:sw=2:sts=2:et:ft=vim
"
" o0-o's personal Neovim configuration.
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" XDG Compliance """""""""""""""""""""""""""""""""""""""""""""""""""""""
set directory=$XDG_CACHE_HOME/nvim,~/,/tmp
set backupdir=$XDG_CACHE_HOME/nvim,~/,/tmp
set viminfo+=n$XDG_CACHE_HOME/nvim/viminfo

" Install vim-plug if not found
if empty(glob(system("printf '%s' \"${XDG_CONFIG_HOME:-$HOME/.config}/nvim/junegunn_vim-plugged\"")))
  silent !curl -fLo system("printf '%s' \"${XDG_CONFIG_HOME:-$HOME/.config}/nvim/junegunn_vim-plugged\"") --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Plugins via junegunn/vim-plug """"""""""""""""""""""""""""""""""""""""
call plug#begin(system("printf '%s' \"${XDG_CONFIG_HOME:-$HOME/.config}/nvim/junegunn_vim-plugged\""))
  Plug 'tpope/vim-sensible'       " defaults
"  Plug 'tpope/vim-surround'       " manipulate quotes, brackets, tags, etc
  Plug 'tpope/vim-repeat'         " extend . repeat to plugins
"  Plug 'tpope/vim-sleuth'         " auto-detect indentation
"  Plug 'ervandew/supertab'        " tab completion
  Plug 'sheerun/vim-polyglot'     " extended syntax detection
  Plug 'darfink/vim-plist'        " plist encoding support
  Plug 'ssh://anonymous@git.netizen.se/vim-preseed', {'branch': 'main'} " debian preseed highlighting
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'yaegassy/coc-ansible', {'do': 'yarn install --frozen-lockfile'}
  Plug 'vim-airline/vim-airline'  " interface theming
"  Plug 'ap/vim-css-color'         " overlay text representations of colors
call plug#end()

" Basics """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible    " don't try to be compatible with legacy vi
set modeline        " allow modelines
set encoding=utf-8
filetype plugin on  " detect file types

" Formatting """""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on                   " enable syntax highlighting
if exists('+termguicolors') " use 24-bit color if possible
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif
colorscheme o

"indenting defaults (does not override vim-sleuth's indenting detection)
if get(g:, '_has_set_default_indent_settings', 0) == 0
  set expandtab     " convert tabs to spaces
  set tabstop=2     " 2-space \t
  set softtabstop=2 " 2-space tab
  set shiftwidth=2  " 2-space indent
  let g:_has_set_default_indent_settings = 1
endif
set showbreak=↪
set list lcs=space:·,trail:·,tab:│· " whitespace indicators - old tab:•·

" CoC """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:coc_global_extensions = [
  \ 'coc-snippets',
  \ 'coc-pairs',
  \ 'coc-prettier',
  \ 'coc-json',
  \ ]

let g:coc_filetype_map = {
  \ 'yaml.ansible': 'ansible',
  \ }

" if hidden is not set, TextEdit might fail.
set hidden " Some servers have issues with backup files, see #649 set nobackup set nowritebackup " Better display for messages set cmdheight=2 " You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
"inoremap <silent><expr> <TAB>
"      \ pumvisible() ? "\<C-n>" :
"      \ <SID>check_back_space() ? "\<TAB>" :
"      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
"inoremap <silent><expr> <c-space> coc#refresh()
" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
"inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
"nmap <silent> [g <Plug>(coc-diagnostic-prev)
"nmap <silent> ]g <Plug>(coc-diagnostic-next)
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
"nmap <silent> gy <Plug>(coc-type-definition)
"nmap <silent> gi <Plug>(coc-implementation)
"nmap <silent> gr <Plug>(coc-references)
" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
"autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
"nmap <F2> <Plug>(coc-rename)
" Remap for format selected region
"xmap <leader>f  <Plug>(coc-format-selected)
"nmap <leader>f  <Plug>(coc-format-selected)
"augroup mygroup
  "autocmd!
  " Setup formatexpr specified filetype(s).
  "autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  "autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
"augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
"xmap <leader>a  <Plug>(coc-codeaction-selected)
"nmap <leader>a  <Plug>(coc-codeaction-selected)
" Remap for do codeAction of current line
"nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
"nmap <leader>qf  <Plug>(coc-fix-current)
" Create mappings for function text object, requires document symbols feature of languageserver.
"xmap if <Plug>(coc-funcobj-i)
"xmap af <Plug>(coc-funcobj-a)
"omap if <Plug>(coc-funcobj-i)
"omap af <Plug>(coc-funcobj-a)
" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
"nmap <silent> <C-d> <Plug>(coc-range-select)
"xmap <silent> <C-d> <Plug>(coc-range-select)
" Use `:Format` to format current buffer
"command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
"command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
"command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
"nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
"nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
"nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
"nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
"nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
"nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
"nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
"nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" Clipboard """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set clipboard+=unnamedplus  " use system clipboard
set go+=a                   " automatically copy visual selection to clipboard

" Interface """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set mouse=a               " enable mouse in all modes
set number relativenumber " relative line numbers and current line number
"status line
set laststatus=2  " always show the status line
set noshowmode    " airline handles this for us
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_tab_count = 0
let g:airline#extensions#tabline#tab_nr_type = 2 " splits and tab number
let g:airline#extensions#tabline#show_tab_type = 0
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline_symbols_ascii = 1
let g:airline_section_a = airline#section#create(['mode'])
let g:airline_section_b = airline#section#create(['%R'])
let g:airline_section_c = airline#section#create(['%F'])
let g:airline_section_x = airline#section#create(['ffenc'])
let g:airline_section_y = airline#section#create(['%p%%[%L]'])
let g:airline_section_z = airline#section#create(['%Y'])

" Behaviors """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set iskeyword-=_                " count underscore as word separator
set wildmode=longest,list,full  " autocompletion
"supertab tab completion
"let g:SuperTabMappingForward = '<s-tab>'
"let g:SuperTabMappingBackward = '<s-c-tab>'
"disable automatic commenting on newline
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
"disable indent triggers
set cinkeys=
autocmd FileType * setlocal indentkeys=
"split open at the bottom and right
set splitbelow splitright

" tmux
set t_ts=]2;
set t_fs=\\

set title

"delete trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e   "
autocmd BufWritePre * %s/\n\+\%$//e
