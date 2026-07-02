if o#should_abort()
  finish
endif

" Fzf: {{{
if exists('g:loaded_fzf') && ! exists('g:fzf_colors')
  let g:fzf_colors = {
    \ 'fg':      ['fg', 'Normal'],
    \ 'bg':      ['bg', 'Normal'],
    \ 'hl':      ['fg', 'Search'],
    \ 'fg+':     ['fg', 'Normal'],
    \ 'bg+':     ['bg', 'Normal'],
    \ 'hl+':     ['fg', 'oOrange'],
    \ 'info':    ['fg', 'oPurple'],
    \ 'border':  ['fg', 'Ignore'],
    \ 'prompt':  ['fg', 'oGreen'],
    \ 'pointer': ['fg', 'Exception'],
    \ 'marker':  ['fg', 'Keyword'],
    \ 'spinner': ['fg', 'Label'],
    \ 'header':  ['fg', 'Comment'],
    \}
endif
"}}}
" ALE: {{{
if exists('g:ale_enabled')
  hi! link ALEError              oErrorLine
  hi! link ALEWarning            oWarnLine
  hi! link ALEInfo               oInfoLine

  hi! link ALEErrorSign          oRed
  hi! link ALEWarningSign        oOrange
  hi! link ALEInfoSign           oCyan

  hi! link ALEVirtualTextError   Comment
  hi! link ALEVirtualTextWarning Comment
endif
" }}}
" CtrlP: {{{
if exists('g:loaded_ctrlp')
  hi! link CtrlPMatch     IncSearch
  hi! link CtrlPBufferHid Normal
endif
" }}}
" GitGutter / gitsigns: {{{
if exists('g:loaded_gitgutter')
  hi! link GitGutterAdd    DiffAdd
  hi! link GitGutterChange DiffChange
  hi! link GitGutterDelete DiffDelete
endif
if has('nvim-0.5') && luaeval("pcall(require, 'gitsigns')")
  " https://github.com/lewis6991/gitsigns.nvim requires nvim > 0.5
  " has('nvim-0.5') checks >= 0.5, so this should be future-proof.
  hi! link GitSignsAdd      DiffAdd
  hi! link GitSignsAddLn    DiffAdd
  hi! link GitSignsAddNr    DiffAdd
  hi! link GitSignsChange   DiffChange
  hi! link GitSignsChangeLn DiffChange
  hi! link GitSignsChangeNr DiffChange
  hi! link GitSignsDelete   DiffDelete
  hi! link GitSignsDeleteLn DiffDelete
  hi! link GitSignsDeleteNr DiffDelete
endif
" }}}
" Tree-sitter: {{{
if exists('g:loaded_nvim_treesitter')
  " # Misc
  hi! link TSPunctSpecial Special
  " # Constants
  hi! link TSConstMacro Macro
  hi! link TSStringEscape Character
  hi! link TSSymbol oPurple
  hi! link TSAnnotation oYellow
  hi! link TSAttribute oGreenItalic
  " # Functions
  hi! link TSFuncBuiltin oCyan
  hi! link TSFuncMacro Function
  hi! link TSParameter oOrangeItalic
  hi! link TSParameterReference oOrange
  hi! link TSField oOrange
  hi! link TSConstructor oCyan
  " # Keywords
  hi! link TSLabel oPurpleItalic
  " # Variable
  hi! link TSVariableBuiltin oPurpleItalic
  " # Text
  hi! link TSStrong oFgBold
  hi! link TSEmphasis oFg
  hi! link TSUnderline Underlined
  hi! link TSTitle oYellow
  hi! link TSLiteral oYellow
  hi! link TSURI oYellow
endif
" }}}

" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0:
