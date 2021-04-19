" Palette: {{{

let g:dracula#palette           = {}
let g:dracula#palette.fg        = ['#F3F3FB', 253]

let g:dracula#palette.bglighter = ['#424460', 238]
let g:dracula#palette.bglight   = ['#2B2D45', 237]
let g:dracula#palette.bg        = ['#151729', 236]
let g:dracula#palette.bgdark    = ['#090910', 235]
let g:dracula#palette.bgdarker  = ['#000000', 234]

let g:dracula#palette.comment   = ['#424460',  61]
let g:dracula#palette.selection = ['#2B2D45', 239]
let g:dracula#palette.subtle    = ['#2B2D45', 238]
let g:dracula#palette.subtlewarn = ['#181B2F', 238]
let g:dracula#palette.subtleerr = ['#2A0415', 238]

let g:dracula#palette.blue      = ['#1443FF', 117]
let g:dracula#palette.lightblue = ['#0080FF', 117]
let g:dracula#palette.darkcyan  = ['#00BCFF', 117]
let g:dracula#palette.cyan      = ['#29FFFF', 117]
let g:dracula#palette.green     = ['#22FF1A',  84]
let g:dracula#palette.orange    = ['#FFA400', 215]
let g:dracula#palette.pink      = ['#FF5CE4', 212]
let g:dracula#palette.purple    = ['#AA48FF', 141]
let g:dracula#palette.red       = ['#FF0043', 203]
let g:dracula#palette.yellow    = ['#FFF800', 228]

"
" ANSI
"
let g:dracula#palette.color_0  = ['#090910', 0]
let g:dracula#palette.color_1  = ['#840529', 1]
let g:dracula#palette.color_2  = ['#1D7B1D', 2]
let g:dracula#palette.color_3  = ['#845A1D', 3]
let g:dracula#palette.color_4  = ['#051C87', 4]
let g:dracula#palette.color_5  = ['#592887', 5]
let g:dracula#palette.color_6  = ['#198487', 6]
let g:dracula#palette.color_7  = ['#F3F3FB', 7]
let g:dracula#palette.color_8  = ['#424460', 8]
let g:dracula#palette.color_9  = ['#FF0043', 9]
let g:dracula#palette.color_10 = ['#22FF1A', 10]
let g:dracula#palette.color_11 = ['#FFF800', 11]
let g:dracula#palette.color_12 = ['#1443FF', 12]
let g:dracula#palette.color_13 = ['#FF5CE4', 13]
let g:dracula#palette.color_14 = ['#29FFFF', 14]
let g:dracula#palette.color_15 = ['#FFFFFF', 15]

" }}}

" Helper function that takes a variadic list of filetypes as args and returns
" whether or not the execution of the ftplugin should be aborted.
func! dracula#should_abort(...)
    if ! exists('g:colors_name') || g:colors_name !=# 'o0-o'
        return 1
    elseif a:0 > 0 && (! exists('b:current_syntax') || index(a:000, b:current_syntax) == -1)
        return 1
    endif
    return 0
endfunction

" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0:
