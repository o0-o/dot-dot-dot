" Palette:

let g:o#palette           = {}

let g:o#palette.black         = ['#040407', 0]
let g:o#palette.red           = ['#FF0044', 1]
let g:o#palette.green         = ['#00E092', 2]
let g:o#palette.yellow        = ['#FF9100', 3]
let g:o#palette.blue          = ['#6458FF', 4]
let g:o#palette.magenta       = ['#C400FF', 5]
let g:o#palette.cyan          = ['#0088FF', 6]
let g:o#palette.white         = ['#8E8EB6', 7]

let g:o#palette.brightblack   = ['#5E5E7D', 8]
let g:o#palette.brightred     = ['#FF4D00', 9]
let g:o#palette.brightgreen   = ['#7CDB00', 10]
let g:o#palette.brightyellow  = ['#E0C600', 11]
let g:o#palette.brightblue    = ['#9D49FD', 12]
let g:o#palette.brightmagenta = ['#FF00BB', 13]
let g:o#palette.brightcyan    = ['#00C4EB', 14]
let g:o#palette.brightwhite   = ['#F3F3FB', 15]

let g:o#palette.dimblack      = ['#000000', 16]
let g:o#palette.dimred        = ['#430C24', 52]
let g:o#palette.dimgreen      = ['#202F1A', 22]
let g:o#palette.dimyellow     = ['#3E2916', 58]
let g:o#palette.dimblue       = ['#120E4C', 17]
let g:o#palette.dimmagenta    = ['#330D4A', 54]
let g:o#palette.dimcyan       = ['#0E2939', 24]
let g:o#palette.dimwhite      = ['#2B2D45', 236]

let g:o#palette.bg            = ['#26273D', 234]
let g:o#palette.bgsubtle      = ['#2A2C4D', 235]

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
