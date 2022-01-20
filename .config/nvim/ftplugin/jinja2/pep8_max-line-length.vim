" vim: ts=2:sw=2:sts=2:et:ft=vim
"
" PEP 8 line length
"
" I use this for most coding/scripting types beyond just Python because
" it allows me to fit several documents side-by-side on a single
" monitor.
"
" https://pep8.org/#maximum-line-length
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" PEP 8 limits comment line length to 72 characters
let &colorcolumn="73"

" Set red background on characters past column 79
autocmd BufEnter * highlight PEPOver ctermbg=52 guibg=#430C24
autocmd BufEnter * match PEPOver /\%80v.*/
