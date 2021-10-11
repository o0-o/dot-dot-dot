" Palette: {{{

let g:o#palette           = {}

"
" ANSI
"
let g:o#palette.color_0       = ['#040407', 0]
let g:o#palette.black         = g:o#palette.color_0
let g:o#palette.color_1       = ['#FF0044', 1]
let g:o#palette.red           = g:o#palette.color_1
let g:o#palette.color_2       = ['#00E092', 2]
let g:o#palette.green         = g:o#palette.color_2
let g:o#palette.color_3       = ['#FF9100', 3]
let g:o#palette.yellow        = g:o#palette.color_3
let g:o#palette.color_4       = ['#4A3DFF', 4]
let g:o#palette.blue          = g:o#palette.color_4
let g:o#palette.color_5       = ['#C400FF', 5]
let g:o#palette.magenta       = g:o#palette.color_5
let g:o#palette.color_6       = ['#0088FF', 6]
let g:o#palette.cyan          = g:o#palette.color_6
let g:o#palette.color_7       = ['#F3F3FB', 7]
let g:o#palette.white         = g:o#palette.color_7
let g:o#palette.color_8       = ['#424460', 8]
let g:o#palette.brightblack   = g:o#palette.color_8
let g:o#palette.color_9       = ['#FF4D00', 9]
let g:o#palette.brightred     = g:o#palette.color_9
let g:o#palette.color_10      = ['#7CDB00', 10]
let g:o#palette.brightgreen   = g:o#palette.color_10
let g:o#palette.color_11      = ['#E0C600', 11]
let g:o#palette.brightyellow  = g:o#palette.color_11
let g:o#palette.color_12      = ['#7C0AFF', 12]
let g:o#palette.brightblue    = g:o#palette.color_12
let g:o#palette.color_13      = ['#FF00BB', 13]
let g:o#palette.brightmagenta = g:o#palette.color_13
let g:o#palette.color_14      = ['#00C4EB', 14]
let g:o#palette.brightcyan    = g:o#palette.color_14
let g:o#palette.color_15      = ['#FFFFFF', 15]
let g:o#palette.brightwhite   = g:o#palette.color_15
let g:o#palette.dimblack      = ['#000000', 16]
let g:o#palette.dimred        = ['#430C24', 52]
let g:o#palette.dimgreen      = ['#202F1A', 22]
let g:o#palette.dimyellow     = ['#3E2916', 58]
let g:o#palette.dimblue       = ['#120E4C', 17]
let g:o#palette.dimmagenta    = ['#330D4A', 54]
let g:o#palette.dimcyan       = ['#0E2939', 24]
let g:o#palette.dimwhite      = ['#2B2D45', 236]


let g:o#palette.fg            = g:o#palette.white

let g:o#palette.bglighter     = g:o#palette.dimwhite
let g:o#palette.bglight       = g:o#palette.brightblack
let g:o#palette.bg            = ['#131525', 234]
let g:o#palette.bgdark        = g:o#palette.black
let g:o#palette.bgdarker      = g:o#palette.dimblack

let g:o#palette.comment       = g:o#palette.brightblack
let g:o#palette.selection     = g:o#palette.dimwhite
let g:o#palette.subtle        = g:o#palette.dimgreen
let g:o#palette.subtlewarn    = ['#1A1D33', 235]
let g:o#palette.subtleerr     = g:o#palette.dimred

let g:o#palette.lightblue     = g:o#palette.cyan
let g:o#palette.darkcyan      = g:o#palette.blue
let g:o#palette.orange        = g:o#palette.yellow
let g:o#palette.pink          = g:o#palette.brightmagenta
let g:o#palette.purple        = g:o#palette.brightblue

" }}}

" Helper function that takes a variadic list of filetypes as args and returns
" whether or not the execution of the ftplugin should be aborted.
func! o#should_abort(...)
    if ! exists('g:colors_name') || g:colors_name !=# 'o0-o'
        return 1
    elseif a:0 > 0 && (! exists('b:current_syntax') || index(a:000, b:current_syntax) == -1)
        return 1
    endif
    return 0
endfunction

" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0:
