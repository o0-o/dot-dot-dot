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

let s:fg        = g:o#palette.fg

let s:bglighter = g:o#palette.bglighter
let s:bglight   = g:o#palette.bglight
let s:bg        = g:o#palette.bg
let s:bgdark    = g:o#palette.bgdark
let s:bgdarker  = g:o#palette.bgdarker

let s:comment   = g:o#palette.comment
let s:selection = g:o#palette.selection
let s:subtle    = g:o#palette.subtle
let s:subtlewarn = g:o#palette.subtlewarn
let s:subtleerr = g:o#palette.subtleerr

let s:cyan      = g:o#palette.cyan
let s:green     = g:o#palette.green
let s:orange    = g:o#palette.orange
let s:pink      = g:o#palette.pink
let s:purple    = g:o#palette.purple
let s:red       = g:o#palette.red
let s:yellow    = g:o#palette.yellow
let s:blue      = g:o#palette.blue
let s:lightblue = g:o#palette.lightblue
let s:darkcyan  = g:o#palette.darkcyan

let s:ansi0     = g:o#palette.color_0
let s:ansi1     = g:o#palette.color_1
let s:ansi2     = g:o#palette.color_2
let s:ansi3     = g:o#palette.color_3
let s:ansi4     = g:o#palette.color_4
let s:ansi5     = g:o#palette.color_5
let s:ansi6     = g:o#palette.color_6
let s:ansi7     = g:o#palette.color_7
let s:ansi8     = g:o#palette.color_8
let s:ansi9     = g:o#palette.color_9
let s:ansi10    = g:o#palette.color_10
let s:ansi11    = g:o#palette.color_11
let s:ansi12    = g:o#palette.color_12
let s:ansi13    = g:o#palette.color_13
let s:ansi14    = g:o#palette.color_14
let s:ansi15    = g:o#palette.color_15


let s:none      = ['NONE', 'NONE']

if has('nvim')
  for s:i in range(16)
    let g:terminal_color_{s:i} = g:o#palette['color_' . s:i]
  endfor
endif

if has('terminal')
  let g:terminal_ansi_colors = []
  for s:i in range(16)
    call add(g:terminal_ansi_colors, g:o#palette['color_' . s:i])
  endfor
endif

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

call s:h('oBgLight', s:none, s:bglight)
call s:h('oBgLighter', s:none, s:bglighter)
call s:h('oBgDark', s:none, s:bgdark)
call s:h('oBgDarker', s:none, s:bgdarker)

call s:h('oFg', s:fg)
call s:h('oFgUnderline', s:fg, s:none, [s:attrs.underline])
call s:h('oFgBold', s:fg, s:none, [s:attrs.bold])

call s:h('oComment', s:comment, s:none, [s:attrs.italic])
call s:h('oCommentBold', s:comment, s:none, [s:attrs.bold])

call s:h('oSelection', s:none, s:selection)

call s:h('oSubtle', s:subtle)
call s:h('oSubtleWarn', s:none, s:subtlewarn)
call s:h('oSubtleErr', s:none, s:subtleerr)

call s:h('oCyan', s:cyan)
call s:h('oCyanItalic', s:cyan, s:none, [s:attrs.italic])

call s:h('oGreen', s:green)
call s:h('oGreenBold', s:green, s:none, [s:attrs.bold])
call s:h('oGreenItalic', s:green, s:none, [s:attrs.italic])
call s:h('oGreenItalicUnderline', s:green, s:none, [s:attrs.italic, s:attrs.underline])

call s:h('oOrange', s:orange)
call s:h('oOrangeBold', s:orange, s:none, [s:attrs.bold])
call s:h('oOrangeItalic', s:orange, s:none, [s:attrs.italic])
call s:h('oOrangeBoldItalic', s:orange, s:none, [s:attrs.bold, s:attrs.italic])
call s:h('oOrangeInverse', s:bg, s:orange)

call s:h('oPink', s:pink)
call s:h('oPinkItalic', s:pink, s:none, [s:attrs.italic])

call s:h('oPurple', s:purple)
call s:h('oPurpleBold', s:purple, s:none, [s:attrs.bold])
call s:h('oPurpleItalic', s:purple, s:none, [s:attrs.italic])

call s:h('oRed', s:red)
call s:h('oRedInverse', s:fg, s:red)

call s:h('oYellow', s:yellow)
call s:h('oYellowItalic', s:yellow, s:none, [s:attrs.italic])

call s:h('oBlue', s:blue)
call s:h('oLightBlue', s:lightblue)
call s:h('oDarkCyan', s:darkcyan)

call s:h('oError', s:red, s:none, [], s:red)

call s:h('oErrorLine', s:none, s:none, [s:attrs.undercurl], s:red)
call s:h('oWarnLine', s:none, s:none, [s:attrs.undercurl], s:orange)
call s:h('oInfoLine', s:none, s:none, [s:attrs.undercurl], s:cyan)

call s:h('oTodo', s:cyan, s:none, [s:attrs.bold, s:attrs.inverse])
call s:h('oSearch', s:none, s:none, [s:attrs.underline])
call s:h('oBoundary', s:comment, s:bgdark)
call s:h('oLink', s:cyan, s:none, [s:attrs.underline])

call s:h('oDiffChange', s:orange, s:none)
call s:h('oDiffText', s:bg, s:orange)
call s:h('oDiffDelete', s:red, s:bgdark)

" }}}2

" }}}
" User Interface: {{{

set background=dark

" Required as some plugins will overwrite
call s:h('Normal', s:fg, g:o_colorterm || has('gui_running') ? s:bg : s:none )
call s:h('StatusLine', s:none, s:bglighter, [s:attrs.bold])
call s:h('StatusLineNC', s:none, s:bglight)
call s:h('StatusLineTerm', s:none, s:bglighter, [s:attrs.bold])
call s:h('StatusLineTermNC', s:none, s:bglight)
call s:h('WildMenu', s:bg, s:purple, [s:attrs.bold])
call s:h('CursorLine', s:none, s:subtle)

hi! link ColorColumn  oSubtleWarn
hi! link CursorColumn CursorLine
hi! link CursorLineNr oYellow
hi! link DiffAdd      oGreen
hi! link DiffAdded    DiffAdd
hi! link DiffChange   oDiffChange
hi! link DiffDelete   oDiffDelete
hi! link DiffRemoved  DiffDelete
hi! link DiffText     oDiffText
hi! link Directory    oPurpleBold
hi! link ErrorMsg     oRedInverse
hi! link FoldColumn   oSubtle
hi! link Folded       oBoundary
hi! link IncSearch    oOrangeInverse
call s:h('LineNr', s:ansi5, s:none)
hi! link MoreMsg      oFgBold
hi! link NonText      oSubtle
hi! link Pmenu        oBgDark
hi! link PmenuSbar    oBgDark
hi! link PmenuSel     oSelection
hi! link PmenuThumb   oSelection
hi! link Question     oFgBold
hi! link Search       oSearch
call s:h('SignColumn', s:comment)
hi! link TabLine      oBoundary
hi! link TabLineFill  oBgDarker
hi! link TabLineSel   Normal
hi! link Title        oGreenBold
hi! link VertSplit    oBoundary
hi! link Visual       oSelection
hi! link VisualNOS    Visual
hi! link WarningMsg   oOrangeInverse

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
  hi! link LspDiagnosticsDefaultError oError
  hi! link LspDiagnosticsDefaultWarning oOrange
  hi! link LspDiagnosticsUnderlineError oErrorLine
  hi! link LspDiagnosticsUnderlineHint oInfoLine
  hi! link LspDiagnosticsUnderlineInformation oInfoLine
  hi! link LspDiagnosticsUnderlineWarning oWarnLine
else
  hi! link SpecialKey oSubtle
endif

hi! link Comment oComment
hi! link Underlined oFgUnderline
hi! link Todo oTodo

hi! link Error oError
hi! link SpellBad oErrorLine
hi! link SpellLocal oWarnLine
hi! link SpellCap oInfoLine
hi! link SpellRare oInfoLine

hi! link Constant oYellow
hi! link String oDarkCyan
hi! link Character oGreen
hi! link Number Constant
hi! link Boolean Constant
hi! link Float Constant

hi! link Identifier oRed
hi! link Function oLightBlue

hi! link Statement oPink
hi! link Conditional oGreen
hi! link Repeat oPink
hi! link Label oPink
hi! link Operator oGreen
hi! link Keyword oPink
hi! link Exception oPink

hi! link PreProc oPink
hi! link Include oPink
hi! link Define oPink
hi! link Macro oPink
hi! link PreCondit oPink
hi! link StorageClass oPink
hi! link Structure oPink
hi! link Typedef oPink

hi! link Type oCyan

hi! link Delimiter oPurple

hi! link Special oOrange
hi! link SpecialComment oCyanItalic
hi! link Tag oCyan
hi! link helpHyperTextJump oLink
hi! link helpCommand oPurple
hi! link helpExample oGreen
hi! link helpBacktick Special

"}}}

" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0 et:
