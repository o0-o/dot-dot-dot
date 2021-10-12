if o#should_abort('lua')
    finish
endif

hi! link luaFunc  oCyan
hi! link luaTable oFg

" tbastos/vim-lua {{{

hi! link luaBraces       oFg
hi! link luaBuiltIn      Constant
hi! link luaDocTag       Keyword
hi! link luaErrHand      oCyan
hi! link luaFuncArgName  oYellowItalic
hi! link luaFuncCall     Function
hi! link luaLocal        Keyword
hi! link luaSpecialTable Constant
hi! link luaSpecialValue oCyan

" }}}

" vim: fdm=marker ts=2 sts=2 sw=2 fdl=0:
