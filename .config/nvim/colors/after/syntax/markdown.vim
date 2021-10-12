if o#should_abort('markdown', 'mkd')
    finish
endif

if b:current_syntax ==# 'mkd'
" plasticboy/vim-markdown {{{1
  hi! link htmlBold       oYellowBold
  hi! link htmlBoldItalic oYellowBoldItalic
  hi! link htmlH1         oBlueBold
  hi! link htmlItalic     oYellowItalic
  hi! link mkdBlockquote  oYellowItalic
  hi! link mkdBold        oYellowBold
  hi! link mkdBoldItalic  oYellowBoldItalic
  hi! link mkdCode        oGreen
  hi! link mkdCodeEnd     oGreen
  hi! link mkdCodeStart   oGreen
  hi! link mkdHeading     oBlueBold
  hi! link mkdInlineUrl   oLink
  hi! link mkdItalic      oYellowItalic
  hi! link mkdLink        oMagenta
  hi! link mkdListItem    oCyan
  hi! link mkdRule        oComment
  hi! link mkdUrl         oLink
"}}}1
elseif b:current_syntax ==# 'markdown'
" Builtin: {{{1
  hi! link markdownBlockquote        oCyan
  hi! link markdownBold              oYellowBold
  hi! link markdownBoldItalic        oYellowBoldItalic
  hi! link markdownCodeBlock         oGreen
  hi! link markdownCode              oGreen
  hi! link markdownCodeDelimiter     oGreen
  hi! link markdownH1                oBlueBold
  hi! link markdownH2                markdownH1
  hi! link markdownH3                markdownH1
  hi! link markdownH4                markdownH1
  hi! link markdownH5                markdownH1
  hi! link markdownH6                markdownH1
  hi! link markdownHeadingDelimiter  markdownH1
  hi! link markdownHeadingRule       markdownH1
  hi! link markdownItalic            oYellowItalic
  hi! link markdownLinkText          oMagenta
  hi! link markdownListMarker        oCyan
  hi! link markdownOrderedListMarker oCyan
  hi! link markdownRule              oComment
  hi! link markdownUrl               oLink
"}}}
endif

" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0:
