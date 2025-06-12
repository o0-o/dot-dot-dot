" o0-o Theme: {{{
"
" Based on https://github.com/zenorocha/dracula-theme
"
" Code licensed under the MIT license
scriptencoding utf8
" }}}

" Configuration: {{{

if v:version > 580
  highlight clear
  if exists('syntax_on')
    syntax reset
  endif
endif

let g:colors_name = 'o'

if !(has('termguicolors') && &termguicolors) && !has('gui_running') && &t_Co != 256
  finish
endif

" Palette: {{{2

let s:black         = g:o#palette.black
let s:red           = g:o#palette.red
let s:green         = g:o#palette.green
let s:yellow        = g:o#palette.yellow
let s:blue          = g:o#palette.blue
let s:magenta       = g:o#palette.magenta
let s:cyan          = g:o#palette.cyan
let s:white         = g:o#palette.white

let s:brightblack   = g:o#palette.brightblack
let s:brightred     = g:o#palette.brightred
let s:brightgreen   = g:o#palette.brightgreen
let s:brightyellow  = g:o#palette.brightyellow
let s:brightblue    = g:o#palette.brightblue
let s:brightmagenta = g:o#palette.brightmagenta
let s:brightcyan    = g:o#palette.brightcyan
let s:brightwhite   = g:o#palette.brightwhite

let s:dimblack      = g:o#palette.dimblack
let s:dimred        = g:o#palette.dimred
let s:dimgreen      = g:o#palette.dimgreen
let s:dimyellow     = g:o#palette.dimyellow
let s:dimblue       = g:o#palette.dimblue
let s:dimmagenta    = g:o#palette.dimmagenta
let s:dimcyan       = g:o#palette.dimcyan
let s:dimwhite      = g:o#palette.dimwhite

let s:bg            = g:o#palette.bg
let s:bgsubtle      = g:o#palette.bgsubtle

let s:none       = ['NONE', 'NONE']

" }}}2
" User Configuration: {{{2

if !exists('g:o_bold')
  let g:o_bold = 1
endif

if !exists('g:o_italic')
  let g:o_italic = 1
endif

if !exists('g:o_underline')
  let g:o_underline = 1
endif

if !exists('g:o_undercurl')
  let g:o_undercurl = g:o_underline
endif

if !exists('g:o_inverse')
  let g:o_inverse = 1
endif

if !exists('g:o_colorterm')
  let g:o_colorterm = 1
endif

"}}}2
" Script Helpers: {{{2

let s:attrs = {
      \ 'bold': g:o_bold == 1 ? 'bold' : 0,
      \ 'italic': g:o_italic == 1 ? 'italic' : 0,
      \ 'underline': g:o_underline == 1 ? 'underline' : 0,
      \ 'undercurl': g:o_undercurl == 1 ? 'undercurl' : 0,
      \ 'inverse': g:o_inverse == 1 ? 'inverse' : 0,
      \}

function! s:h(scope, fg, ...) " bg, attr_list, special
  let l:fg = copy(a:fg)
  let l:bg = get(a:, 1, ['NONE', 'NONE'])

  let l:attr_list = filter(get(a:, 2, ['NONE']), 'type(v:val) == 1')
  let l:attrs = len(l:attr_list) > 0 ? join(l:attr_list, ',') : 'NONE'

  " Falls back to coloring foreground group on terminals because
  " nearly all do not support undercurl
  let l:special = get(a:, 3, ['NONE', 'NONE'])
  if l:special[0] !=# 'NONE' && l:fg[0] ==# 'NONE' && !has('gui_running')
    let l:fg[0] = l:special[0]
    let l:fg[1] = l:special[1]
  endif

  let l:hl_string = [
        \ 'highlight', a:scope,
        \ 'guifg=' . l:fg[0], 'ctermfg=' . l:fg[1],
        \ 'guibg=' . l:bg[0], 'ctermbg=' . l:bg[1],
        \ 'gui=' . l:attrs, 'cterm=' . l:attrs,
        \ 'guisp=' . l:special[0],
        \]

  execute join(l:hl_string, ' ')
endfunction

"}}}2
" o Highlight Groups: {{{2

call s:h('oBg', s:none, s:bg)
call s:h('oBgSubtle', s:none, s:bgsubtle)
call s:h('oBgBrightBlack', s:none, s:brightblack)
call s:h('oBgDimWhite', s:none, s:dimwhite)
call s:h('oBgBlack', s:none, s:black)
call s:h('oBgDimBlack', s:none, s:dimblack)
call s:h('oBgRed', s:none, s:dimred)
call s:h('oBgGreen', s:none, s:dimgreen)
call s:h('oBgYellow', s:none, s:dimyellow)
call s:h('oBgBlue', s:none, s:dimblue)
call s:h('oBgMagenta', s:none, s:dimmagenta)
call s:h('oBgCyan', s:none, s:dimcyan)

call s:h('oRed', s:red)
call s:h('oRedInverse', s:bg, s:red)
call s:h('oRedBold', s:red, s:none, [s:attrs.bold])
call s:h('oRedInverseBold', s:bg, s:red, [s:attrs.bold])
call s:h('oRedItalic', s:red, s:none, [s:attrs.italic])
call s:h('oRedInverseItalic', s:bg, s:red, [s:attrs.italic])
call s:h('oRedBoldItalic', s:red, s:none, [s:attrs.bold, s:attrs.italic])
call s:h('oRedInverseBoldItalic', s:bg, s:red, [s:attrs.bold, s:attrs.italic])
call s:h('oRedUnderline', s:red, s:none, [s:attrs.underline])
call s:h('oRedInverseUnderline', s:bg, s:red, [s:attrs.underline])
call s:h('oRedBoldUnderline', s:red, s:none, [s:attrs.bold, s:attrs.underline])
call s:h('oRedInverseBoldUnderline', s:bg, s:red, [s:attrs.bold, s:attrs.underline])
call s:h('oRedBoldItalicUnderline', s:red, s:none, [s:attrs.bold, s:attrs.italic, s:attrs.underline])
call s:h('oRedInverseBoldItalicUnderline', s:bg, s:red, [s:attrs.bold, s:attrs.italic, s:attrs.underline])
call s:h('oRedItalicUnderline', s:red, s:none, [s:attrs.italic, s:attrs.underline])
call s:h('oRedInverseItalicUnderline', s:bg, s:red, [s:attrs.italic, s:attrs.underline])

call s:h('oGreen', s:green)
call s:h('oGreenInverse', s:bg, s:green)
call s:h('oGreenBold', s:green, s:none, [s:attrs.bold])
call s:h('oGreenInverseBold', s:bg, s:green, [s:attrs.bold])
call s:h('oGreenItalic', s:green, s:none, [s:attrs.italic])
call s:h('oGreenInverseItalic', s:bg, s:green, [s:attrs.italic])
call s:h('oGreenBoldItalic', s:green, s:none, [s:attrs.bold, s:attrs.italic])
call s:h('oGreenInverseBoldItalic', s:bg, s:green, [s:attrs.bold, s:attrs.italic])
call s:h('oGreenUnderline', s:green, s:none, [s:attrs.underline])
call s:h('oGreenInverseUnderline', s:bg, s:green, [s:attrs.underline])
call s:h('oGreenBoldUnderline', s:green, s:none, [s:attrs.bold, s:attrs.underline])
call s:h('oGreenInverseBoldUnderline', s:bg, s:green, [s:attrs.bold, s:attrs.underline])
call s:h('oGreenBoldItalicUnderline', s:green, s:none, [s:attrs.bold, s:attrs.italic, s:attrs.underline])
call s:h('oGreenInverseBoldItalicUnderline', s:bg, s:green, [s:attrs.bold, s:attrs.italic, s:attrs.underline])
call s:h('oGreenItalicUnderline', s:green, s:none, [s:attrs.italic, s:attrs.underline])
call s:h('oGreenInverseItalicUnderline', s:bg, s:green, [s:attrs.italic, s:attrs.underline])

call s:h('oYellow', s:yellow)
call s:h('oYellowInverse', s:bg, s:yellow)
call s:h('oYellowBold', s:yellow, s:none, [s:attrs.bold])
call s:h('oYellowInverseBold', s:bg, s:yellow, [s:attrs.bold])
call s:h('oYellowItalic', s:yellow, s:none, [s:attrs.italic])
call s:h('oYellowInverseItalic', s:bg, s:yellow, [s:attrs.italic])
call s:h('oYellowBoldItalic', s:yellow, s:none, [s:attrs.bold, s:attrs.italic])
call s:h('oYellowInverseBoldItalic', s:bg, s:yellow, [s:attrs.bold, s:attrs.italic])
call s:h('oYellowUnderline', s:yellow, s:none, [s:attrs.underline])
call s:h('oYellowInverseUnderline', s:bg, s:yellow, [s:attrs.underline])
call s:h('oYellowBoldUnderline', s:yellow, s:none, [s:attrs.bold, s:attrs.underline])
call s:h('oYellowInverseBoldUnderline', s:bg, s:yellow, [s:attrs.bold, s:attrs.underline])
call s:h('oYellowBoldItalicUnderline', s:yellow, s:none, [s:attrs.bold, s:attrs.italic, s:attrs.underline])
call s:h('oYellowInverseBoldItalicUnderline', s:bg, s:yellow, [s:attrs.bold, s:attrs.italic, s:attrs.underline])
call s:h('oYellowItalicUnderline', s:yellow, s:none, [s:attrs.italic, s:attrs.underline])
call s:h('oYellowInverseItalicUnderline', s:bg, s:yellow, [s:attrs.italic, s:attrs.underline])

call s:h('oBlue', s:blue)
call s:h('oBlueInverse', s:bg, s:blue)
call s:h('oBlueBold', s:blue, s:none, [s:attrs.bold])
call s:h('oBlueInverseBold', s:bg, s:blue, [s:attrs.bold])
call s:h('oBlueItalic', s:blue, s:none, [s:attrs.italic])
call s:h('oBlueInverseItalic', s:bg, s:blue, [s:attrs.italic])
call s:h('oBlueBoldItalic', s:blue, s:none, [s:attrs.bold, s:attrs.italic])
call s:h('oBlueInverseBoldItalic', s:bg, s:blue, [s:attrs.bold, s:attrs.italic])
call s:h('oBlueUnderline', s:blue, s:none, [s:attrs.underline])
call s:h('oBlueInverseUnderline', s:bg, s:blue, [s:attrs.underline])
call s:h('oBlueBoldUnderline', s:blue, s:none, [s:attrs.bold, s:attrs.underline])
call s:h('oBlueInverseBoldUnderline', s:bg, s:blue, [s:attrs.bold, s:attrs.underline])
call s:h('oBlueBoldItalicUnderline', s:blue, s:none, [s:attrs.bold, s:attrs.italic, s:attrs.underline])
call s:h('oBlueInverseBoldItalicUnderline', s:bg, s:blue, [s:attrs.bold, s:attrs.italic, s:attrs.underline])
call s:h('oBlueItalicUnderline', s:blue, s:none, [s:attrs.italic, s:attrs.underline])
call s:h('oBlueInverseItalicUnderline', s:bg, s:blue, [s:attrs.italic, s:attrs.underline])

call s:h('oMagenta', s:magenta)
call s:h('oMagentaInverse', s:bg, s:magenta)
call s:h('oMagentaBold', s:magenta, s:none, [s:attrs.bold])
call s:h('oMagentaInverseBold', s:bg, s:magenta, [s:attrs.bold])
call s:h('oMagentaItalic', s:magenta, s:none, [s:attrs.italic])
call s:h('oMagentaInverseItalic', s:bg, s:magenta, [s:attrs.italic])
call s:h('oMagentaBoldItalic', s:magenta, s:none, [s:attrs.bold, s:attrs.italic])
call s:h('oMagentaInverseBoldItalic', s:bg, s:magenta, [s:attrs.bold, s:attrs.italic])
call s:h('oMagentaUnderline', s:magenta, s:none, [s:attrs.underline])
call s:h('oMagentaInverseUnderline', s:bg, s:magenta, [s:attrs.underline])
call s:h('oMagentaBoldUnderline', s:magenta, s:none, [s:attrs.bold, s:attrs.underline])
call s:h('oMagentaInverseBoldUnderline', s:bg, s:magenta, [s:attrs.bold, s:attrs.underline])
call s:h('oMagentaBoldItalicUnderline', s:magenta, s:none, [s:attrs.bold, s:attrs.italic, s:attrs.underline])
call s:h('oMagentaInverseBoldItalicUnderline', s:bg, s:magenta, [s:attrs.bold, s:attrs.italic, s:attrs.underline])
call s:h('oMagentaItalicUnderline', s:magenta, s:none, [s:attrs.italic, s:attrs.underline])
call s:h('oMagentaInverseItalicUnderline', s:bg, s:magenta, [s:attrs.italic, s:attrs.underline])

call s:h('oCyan', s:cyan)
call s:h('oCyanInverse', s:bg, s:cyan)
call s:h('oCyanBold', s:cyan, s:none, [s:attrs.bold])
call s:h('oCyanInverseBold', s:bg, s:cyan, [s:attrs.bold])
call s:h('oCyanItalic', s:cyan, s:none, [s:attrs.italic])
call s:h('oCyanInverseItalic', s:bg, s:cyan, [s:attrs.italic])
call s:h('oCyanBoldItalic', s:cyan, s:none, [s:attrs.bold, s:attrs.italic])
call s:h('oCyanInverseBoldItalic', s:bg, s:cyan, [s:attrs.bold, s:attrs.italic])
call s:h('oCyanUnderline', s:cyan, s:none, [s:attrs.underline])
call s:h('oCyanInverseUnderline', s:bg, s:cyan, [s:attrs.underline])
call s:h('oCyanBoldUnderline', s:cyan, s:none, [s:attrs.bold, s:attrs.underline])
call s:h('oCyanInverseBoldUnderline', s:bg, s:cyan, [s:attrs.bold, s:attrs.underline])
call s:h('oCyanBoldItalicUnderline', s:cyan, s:none, [s:attrs.bold, s:attrs.italic, s:attrs.underline])
call s:h('oCyanInverseBoldItalicUnderline', s:bg, s:cyan, [s:attrs.bold, s:attrs.italic, s:attrs.underline])
call s:h('oCyanItalicUnderline', s:cyan, s:none, [s:attrs.italic, s:attrs.underline])
call s:h('oCyanInverseItalicUnderline', s:bg, s:cyan, [s:attrs.italic, s:attrs.underline])

call s:h('oWhite', s:white)
call s:h('oWhiteInverse', s:bg, s:white)
call s:h('oWhiteBold', s:white, s:none, [s:attrs.bold])
call s:h('oWhiteInverseBold', s:bg, s:white, [s:attrs.bold])
call s:h('oWhiteItalic', s:white, s:none, [s:attrs.italic])
call s:h('oWhiteInverseItalic', s:bg, s:white, [s:attrs.italic])
call s:h('oWhiteBoldItalic', s:white, s:none, [s:attrs.bold, s:attrs.italic])
call s:h('oWhiteInverseBoldItalic', s:bg, s:white, [s:attrs.bold, s:attrs.italic])
call s:h('oWhiteUnderline', s:white, s:none, [s:attrs.underline])
call s:h('oWhiteInverseUnderline', s:bg, s:white, [s:attrs.underline])
call s:h('oWhiteBoldUnderline', s:white, s:none, [s:attrs.bold, s:attrs.underline])
call s:h('oWhiteInverseBoldUnderline', s:bg, s:white, [s:attrs.bold, s:attrs.underline])
call s:h('oWhiteBoldItalicUnderline', s:white, s:none, [s:attrs.bold, s:attrs.italic, s:attrs.underline])
call s:h('oWhiteInverseBoldItalicUnderline', s:bg, s:white, [s:attrs.bold, s:attrs.italic, s:attrs.underline])
call s:h('oWhiteItalicUnderline', s:white, s:none, [s:attrs.italic, s:attrs.underline])
call s:h('oWhiteInverseItalicUnderline', s:bg, s:white, [s:attrs.italic, s:attrs.underline])

call s:h('oBrightBlack', s:brightblack)
call s:h('oBrightBlackInverse', s:bg, s:brightblack)
call s:h('oBrightBlackBold', s:brightblack, s:none, [s:attrs.bold])
call s:h('oBrightBlackInverseBold', s:bg, s:brightblack, [s:attrs.bold])
call s:h('oBrightBlackItalic', s:brightblack, s:none, [s:attrs.italic])
call s:h('oBrightBlackInverseItalic', s:bg, s:brightblack, [s:attrs.italic])
call s:h('oBrightBlackBoldItalic', s:brightblack, s:none, [s:attrs.bold, s:attrs.italic])
call s:h('oBrightBlackInverseBoldItalic', s:bg, s:brightblack, [s:attrs.bold, s:attrs.italic])
call s:h('oBrightBlackUnderline', s:brightblack, s:none, [s:attrs.underline])
call s:h('oBrightBlackInverseUnderline', s:bg, s:brightblack, [s:attrs.underline])
call s:h('oBrightBlackBoldUnderline', s:brightblack, s:none, [s:attrs.bold, s:attrs.underline])
call s:h('oBrightBlackInverseBoldUnderline', s:bg, s:brightblack, [s:attrs.bold, s:attrs.underline])
call s:h('oBrightBlackBoldItalicUnderline', s:brightblack, s:none, [s:attrs.bold, s:attrs.italic, s:attrs.underline])
call s:h('oBrightBlackInverseBoldItalicUnderline', s:bg, s:brightblack, [s:attrs.bold, s:attrs.italic, s:attrs.underline])
call s:h('oBrightBlackItalicUnderline', s:brightblack, s:none, [s:attrs.italic, s:attrs.underline])
call s:h('oBrightBlackInverseItalicUnderline', s:bg, s:brightblack, [s:attrs.italic, s:attrs.underline])

call s:h('oBrightRed', s:brightred)
call s:h('oBrightRedInverse', s:bg, s:brightred)
call s:h('oBrightRedBold', s:brightred, s:none, [s:attrs.bold])
call s:h('oBrightRedInverseBold', s:bg, s:brightred, [s:attrs.bold])
call s:h('oBrightRedItalic', s:brightred, s:none, [s:attrs.italic])
call s:h('oBrightRedInverseItalic', s:bg, s:brightred, [s:attrs.italic])
call s:h('oBrightRedBoldItalic', s:brightred, s:none, [s:attrs.bold, s:attrs.italic])
call s:h('oBrightRedInverseBoldItalic', s:bg, s:brightred, [s:attrs.bold, s:attrs.italic])
call s:h('oBrightRedUnderline', s:brightred, s:none, [s:attrs.underline])
call s:h('oBrightRedInverseUnderline', s:bg, s:brightred, [s:attrs.underline])
call s:h('oBrightRedBoldUnderline', s:brightred, s:none, [s:attrs.bold, s:attrs.underline])
call s:h('oBrightRedInverseBoldUnderline', s:bg, s:brightred, [s:attrs.bold, s:attrs.underline])
call s:h('oBrightRedBoldItalicUnderline', s:brightred, s:none, [s:attrs.bold, s:attrs.italic, s:attrs.underline])
call s:h('oBrightRedInverseBoldItalicUnderline', s:bg, s:brightred, [s:attrs.bold, s:attrs.italic, s:attrs.underline])
call s:h('oBrightRedItalicUnderline', s:brightred, s:none, [s:attrs.italic, s:attrs.underline])
call s:h('oBrightRedInverseItalicUnderline', s:bg, s:brightred, [s:attrs.italic, s:attrs.underline])

call s:h('oBrightGreen', s:brightgreen)
call s:h('oBrightGreenInverse', s:bg, s:brightgreen)
call s:h('oBrightGreenBold', s:brightgreen, s:none, [s:attrs.bold])
call s:h('oBrightGreenInverseBold', s:bg, s:brightgreen, [s:attrs.bold])
call s:h('oBrightGreenItalic', s:brightgreen, s:none, [s:attrs.italic])
call s:h('oBrightGreenInverseItalic', s:bg, s:brightgreen, [s:attrs.italic])
call s:h('oBrightGreenBoldItalic', s:brightgreen, s:none, [s:attrs.bold, s:attrs.italic])
call s:h('oBrightGreenInverseBoldItalic', s:bg, s:brightgreen, [s:attrs.bold, s:attrs.italic])
call s:h('oBrightGreenUnderline', s:brightgreen, s:none, [s:attrs.underline])
call s:h('oBrightGreenInverseUnderline', s:bg, s:brightgreen, [s:attrs.underline])
call s:h('oBrightGreenBoldUnderline', s:brightgreen, s:none, [s:attrs.bold, s:attrs.underline])
call s:h('oBrightGreenInverseBoldUnderline', s:bg, s:brightgreen, [s:attrs.bold, s:attrs.underline])
call s:h('oBrightGreenBoldItalicUnderline', s:brightgreen, s:none, [s:attrs.bold, s:attrs.italic, s:attrs.underline])
call s:h('oBrightGreenInverseBoldItalicUnderline', s:bg, s:brightgreen, [s:attrs.bold, s:attrs.italic, s:attrs.underline])
call s:h('oBrightGreenItalicUnderline', s:brightgreen, s:none, [s:attrs.italic, s:attrs.underline])
call s:h('oBrightGreenInverseItalicUnderline', s:bg, s:brightgreen, [s:attrs.italic, s:attrs.underline])

call s:h('oBrightYellow', s:brightyellow)
call s:h('oBrightYellowInverse', s:bg, s:brightyellow)
call s:h('oBrightYellowBold', s:brightyellow, s:none, [s:attrs.bold])
call s:h('oBrightYellowInverseBold', s:bg, s:brightyellow, [s:attrs.bold])
call s:h('oBrightYellowItalic', s:brightyellow, s:none, [s:attrs.italic])
call s:h('oBrightYellowInverseItalic', s:bg, s:brightyellow, [s:attrs.italic])
call s:h('oBrightYellowBoldItalic', s:brightyellow, s:none, [s:attrs.bold, s:attrs.italic])
call s:h('oBrightYellowInverseBoldItalic', s:bg, s:brightyellow, [s:attrs.bold, s:attrs.italic])
call s:h('oBrightYellowUnderline', s:brightyellow, s:none, [s:attrs.underline])
call s:h('oBrightYellowInverseUnderline', s:bg, s:brightyellow, [s:attrs.underline])
call s:h('oBrightYellowBoldUnderline', s:brightyellow, s:none, [s:attrs.bold, s:attrs.underline])
call s:h('oBrightYellowInverseBoldUnderline', s:bg, s:brightyellow, [s:attrs.bold, s:attrs.underline])
call s:h('oBrightYellowBoldItalicUnderline', s:brightyellow, s:none, [s:attrs.bold, s:attrs.italic, s:attrs.underline])
call s:h('oBrightYellowInverseBoldItalicUnderline', s:bg, s:brightyellow, [s:attrs.bold, s:attrs.italic, s:attrs.underline])
call s:h('oBrightYellowItalicUnderline', s:brightyellow, s:none, [s:attrs.italic, s:attrs.underline])
call s:h('oBrightYellowInverseItalicUnderline', s:bg, s:brightyellow, [s:attrs.italic, s:attrs.underline])

call s:h('oBrightBlue', s:brightblue)
call s:h('oBrightBlueInverse', s:bg, s:brightblue)
call s:h('oBrightBlueBold', s:brightblue, s:none, [s:attrs.bold])
call s:h('oBrightBlueInverseBold', s:bg, s:brightblue, [s:attrs.bold])
call s:h('oBrightBlueItalic', s:brightblue, s:none, [s:attrs.italic])
call s:h('oBrightBlueInverseItalic', s:bg, s:brightblue, [s:attrs.italic])
call s:h('oBrightBlueBoldItalic', s:brightblue, s:none, [s:attrs.bold, s:attrs.italic])
call s:h('oBrightBlueInverseBoldItalic', s:bg, s:brightblue, [s:attrs.bold, s:attrs.italic])
call s:h('oBrightBlueUnderline', s:brightblue, s:none, [s:attrs.underline])
call s:h('oBrightBlueInverseUnderline', s:bg, s:brightblue, [s:attrs.underline])
call s:h('oBrightBlueBoldUnderline', s:brightblue, s:none, [s:attrs.bold, s:attrs.underline])
call s:h('oBrightBlueInverseBoldUnderline', s:bg, s:brightblue, [s:attrs.bold, s:attrs.underline])
call s:h('oBrightBlueBoldItalicUnderline', s:brightblue, s:none, [s:attrs.bold, s:attrs.italic, s:attrs.underline])
call s:h('oBrightBlueInverseBoldItalicUnderline', s:bg, s:brightblue, [s:attrs.bold, s:attrs.italic, s:attrs.underline])
call s:h('oBrightBlueItalicUnderline', s:brightblue, s:none, [s:attrs.italic, s:attrs.underline])
call s:h('oBrightBlueInverseItalicUnderline', s:bg, s:brightblue, [s:attrs.italic, s:attrs.underline])

call s:h('oBrightMagenta', s:brightmagenta)
call s:h('oBrightMagentaInverse', s:bg, s:brightmagenta)
call s:h('oBrightMagentaBold', s:brightmagenta, s:none, [s:attrs.bold])
call s:h('oBrightMagentaInverseBold', s:bg, s:brightmagenta, [s:attrs.bold])
call s:h('oBrightMagentaItalic', s:brightmagenta, s:none, [s:attrs.italic])
call s:h('oBrightMagentaInverseItalic', s:bg, s:brightmagenta, [s:attrs.italic])
call s:h('oBrightMagentaBoldItalic', s:brightmagenta, s:none, [s:attrs.bold, s:attrs.italic])
call s:h('oBrightMagentaInverseBoldItalic', s:bg, s:brightmagenta, [s:attrs.bold, s:attrs.italic])
call s:h('oBrightMagentaUnderline', s:brightmagenta, s:none, [s:attrs.underline])
call s:h('oBrightMagentaInverseUnderline', s:bg, s:brightmagenta, [s:attrs.underline])
call s:h('oBrightMagentaBoldUnderline', s:brightmagenta, s:none, [s:attrs.bold, s:attrs.underline])
call s:h('oBrightMagentaInverseBoldUnderline', s:bg, s:brightmagenta, [s:attrs.bold, s:attrs.underline])
call s:h('oBrightMagentaBoldItalicUnderline', s:brightmagenta, s:none, [s:attrs.bold, s:attrs.italic, s:attrs.underline])
call s:h('oBrightMagentaInverseBoldItalicUnderline', s:bg, s:brightmagenta, [s:attrs.bold, s:attrs.italic, s:attrs.underline])
call s:h('oBrightMagentaItalicUnderline', s:brightmagenta, s:none, [s:attrs.italic, s:attrs.underline])
call s:h('oBrightMagentaInverseItalicUnderline', s:bg, s:brightmagenta, [s:attrs.italic, s:attrs.underline])

call s:h('oBrightCyan', s:brightcyan)
call s:h('oBrightCyanInverse', s:bg, s:brightcyan)
call s:h('oBrightCyanBold', s:brightcyan, s:none, [s:attrs.bold])
call s:h('oBrightCyanInverseBold', s:bg, s:brightcyan, [s:attrs.bold])
call s:h('oBrightCyanItalic', s:brightcyan, s:none, [s:attrs.italic])
call s:h('oBrightCyanInverseItalic', s:bg, s:brightcyan, [s:attrs.italic])
call s:h('oBrightCyanBoldItalic', s:brightcyan, s:none, [s:attrs.bold, s:attrs.italic])
call s:h('oBrightCyanInverseBoldItalic', s:bg, s:brightcyan, [s:attrs.bold, s:attrs.italic])
call s:h('oBrightCyanUnderline', s:brightcyan, s:none, [s:attrs.underline])
call s:h('oBrightCyanInverseUnderline', s:bg, s:brightcyan, [s:attrs.underline])
call s:h('oBrightCyanBoldUnderline', s:brightcyan, s:none, [s:attrs.bold, s:attrs.underline])
call s:h('oBrightCyanInverseBoldUnderline', s:bg, s:brightcyan, [s:attrs.bold, s:attrs.underline])
call s:h('oBrightCyanBoldItalicUnderline', s:brightcyan, s:none, [s:attrs.bold, s:attrs.italic, s:attrs.underline])
call s:h('oBrightCyanInverseBoldItalicUnderline', s:bg, s:brightcyan, [s:attrs.bold, s:attrs.italic, s:attrs.underline])
call s:h('oBrightCyanItalicUnderline', s:brightcyan, s:none, [s:attrs.italic, s:attrs.underline])
call s:h('oBrightCyanInverseItalicUnderline', s:bg, s:brightcyan, [s:attrs.italic, s:attrs.underline])

call s:h('oBrightWhite', s:brightwhite)
call s:h('oBrightWhiteInverse', s:bg, s:brightwhite)
call s:h('oBrightWhiteBold', s:brightwhite, s:none, [s:attrs.bold])
call s:h('oBrightWhiteInverseBold', s:bg, s:brightwhite, [s:attrs.bold])
call s:h('oBrightWhiteItalic', s:brightwhite, s:none, [s:attrs.italic])
call s:h('oBrightWhiteInverseItalic', s:bg, s:brightwhite, [s:attrs.italic])
call s:h('oBrightWhiteBoldItalic', s:brightwhite, s:none, [s:attrs.bold, s:attrs.italic])
call s:h('oBrightWhiteInverseBoldItalic', s:bg, s:brightwhite, [s:attrs.bold, s:attrs.italic])
call s:h('oBrightWhiteUnderline', s:brightwhite, s:none, [s:attrs.underline])
call s:h('oBrightWhiteInverseUnderline', s:bg, s:brightwhite, [s:attrs.underline])
call s:h('oBrightWhiteBoldUnderline', s:brightwhite, s:none, [s:attrs.bold, s:attrs.underline])
call s:h('oBrightWhiteInverseBoldUnderline', s:bg, s:brightwhite, [s:attrs.bold, s:attrs.underline])
call s:h('oBrightWhiteBoldItalicUnderline', s:brightwhite, s:none, [s:attrs.bold, s:attrs.italic, s:attrs.underline])
call s:h('oBrightWhiteInverseBoldItalicUnderline', s:bg, s:brightwhite, [s:attrs.bold, s:attrs.italic, s:attrs.underline])
call s:h('oBrightWhiteItalicUnderline', s:brightwhite, s:none, [s:attrs.italic, s:attrs.underline])
call s:h('oBrightWhiteInverseItalicUnderline', s:bg, s:brightwhite, [s:attrs.italic, s:attrs.underline])

call s:h('oBold', s:none, s:none, [s:attrs.bold])
call s:h('oItalic', s:none, s:none, [s:attrs.italic])
call s:h('oBoldItalic', s:none, s:none, [s:attrs.bold, s:attrs.italic])
call s:h('oUnderline', s:none, s:none, [s:attrs.underline])
call s:h('oBoldUnderline', s:none, s:none, [s:attrs.bold, s:attrs.underline])
call s:h('oItalicUnderline', s:none, s:none, [s:attrs.italic, s:attrs.underline])
call s:h('oBoldItalicUnderline', s:none, s:none, [s:attrs.bold, s:attrs.italic, s:attrs.underline])

call s:h('oDimWhite', s:dimwhite)
call s:h('oSubtle', s:brightblack)

" }}}2

" }}}
" User Interface: {{{

set background=dark

" Required as some plugins will overwrite
call s:h('Normal', s:brightwhite, s:none)
call s:h('StatusLine', s:none, s:brightblack, [s:attrs.bold])
call s:h('StatusLineNC', s:none, s:dimwhite)
call s:h('StatusLineTerm', s:none, s:brightblack, [s:attrs.bold])
call s:h('StatusLineTermNC', s:none, s:dimwhite)
call s:h('WildMenu', s:bg, s:brightblue, [s:attrs.bold])
call s:h('CursorLine', s:none, s:black)
call s:h('CursorLineNr', s:brightwhite, s:black, [s:attrs.bold])

"hi! link TreesitterContext oBgBlack
"hi! link yamlPlainScalar oBlue
"hi! link yamlFlowString oBlue
"hi! link yamlBool     oCyan
hi! link Whitespace   oSubtle
hi! link NonText      Whitespace
hi! link ColorColumn  oBgSubtle
hi! link CursorColumn CursorLine
"hi! link CursorLineNr oBrightMagentaInverse
hi! link DiffAdd      oGreen
hi! link DiffAdded    DiffAdd
hi! link DiffChange   oBrightYellow
hi! link DiffDelete   oBrightRed
hi! link DiffRemoved  DiffDelete
hi! link DiffText     oBlue
hi! link Directory    oBrightBlueBold
hi! link ErrorMsg     oRedInverse
hi! link FoldColumn   oSubtle
hi! link Folded       oBgDimWhite
hi! link IncSearch    oYellowInverse
hi! link LineNr       oBrightBlack
"call s:h('LineNr', s:brightblue, s:black)
hi! link MoreMsg      oWhiteBold
hi! link Pmenu        oBgDimBlack
hi! link PmenuSbar    oBgDimBlack
hi! link PmenuSel     oYellowInverseBold
hi! link PmenuThumb   oYellowInverseBold
hi! link Question     oWhiteBold
hi! link Search       oUnderline
"call s:h('SignColumn', s:brightblack)
hi! link TabLine      oBgDimWhite
hi! link TabLineFill  oBgDimBlack
hi! link TabLineSel   Normal
hi! link Title        oGreenBold
hi! link VertSplit    oBgDimWhite
hi! link Visual       oBgSubtle
hi! link VisualNOS    Visual
hi! link WarningMsg   oYellowInverse

" }}}
" Syntax: {{{

" Required as some plugins will overwrite
call s:h('MatchParen', s:green, s:none, [s:attrs.underline])
call s:h('Conceal', s:cyan, s:none)

" Neovim uses SpecialKey for escape characters only. Vim uses it for that, plus whitespace.
if has('nvim')
  hi! link SpecialKey oRed
  hi! link LspDiagnosticsDefaultInformation oCyan
  hi! link LspDiagnosticsDefaultHint oCyan
  hi! link LspDiagnosticsDefaultError oRedInverse
  hi! link LspDiagnosticsDefaultWarning oYellow
  hi! link LspDiagnosticsUnderlineError oRedInverse
  hi! link LspDiagnosticsUnderlineHint oCyanInverse
  hi! link LspDiagnosticsUnderlineInformation oCyanInverse
  hi! link LspDiagnosticsUnderlineWarning oYellowInverse
else
  hi! link SpecialKey oDimWhite
endif

hi! link Comment oWhite
hi! link Underlined oUnderline
hi! link Todo oBrightGreenUnderline

hi! link Error oRed
hi! link SpellBad oRedInverse
hi! link SpellLocal oYellowInverse
hi! link SpellCap oCyanInvers
hi! link SpellRare oCyanInverse

hi! link Constant oBrightRed
hi! link String oCyan
hi! link Character oBrightGreen
hi! link Number oBrightGreen
hi! link Boolean Number
hi! link Float Number

hi! link Identifier oMagenta
hi! link Function oBrightYellow

hi! link Statement oGreen
hi! link Conditional oBlue
hi! link Repeat oBrightMagenta
hi! link Label oBrightMagenta
hi! link Operator oYellow
hi! link Keyword oBrightMagenta
hi! link Exception oBrightMagenta

hi! link PreProc oMagenta
hi! link Include oBrightMagenta
hi! link Define oBrightMagenta
hi! link Macro oBrightMagenta
hi! link PreCondit oBrightMagenta
hi! link StorageClass oBrightMagenta
hi! link Structure oBrightMagenta
hi! link Typedef oBrightMagenta

hi! link Type oCyan

hi! link Delimiter oMagenta

hi! link Special oBrightCyan
hi! link SpecialComment oBrightBlackBold
hi! link Tag oCyan
hi! link helpHyperTextJump oBoldUnderline
hi! link helpCommand oBlue
hi! link helpExample oGreen
hi! link helpBacktick Special

"}}}

" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0 et:
