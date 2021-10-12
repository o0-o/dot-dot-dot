if o#should_abort('perl')
    finish
endif

" Regex
hi! link perlMatchStartEnd       oRed

" Builtin functions
hi! link perlOperator            oCyan
hi! link perlStatementFiledesc   oCyan
hi! link perlStatementFiles      oCyan
hi! link perlStatementFlow       oCyan
hi! link perlStatementHash       oCyan
hi! link perlStatementIOfunc     oCyan
hi! link perlStatementIPC        oCyan
hi! link perlStatementList       oCyan
hi! link perlStatementMisc       oCyan
hi! link perlStatementNetwork    oCyan
hi! link perlStatementNumeric    oCyan
hi! link perlStatementProc       oCyan
hi! link perlStatementPword      oCyan
hi! link perlStatementRegexp     oCyan
hi! link perlStatementScalar     oCyan
hi! link perlStatementSocket     oCyan
hi! link perlStatementTime       oCyan
hi! link perlStatementVector     oCyan

" Highlighting for quoting constructs, tied to existing option in vim-perl
if get(g:, 'perl_string_as_statement', 0)
  hi! link perlStringStartEnd oRed
endif

" Signatures
hi! link perlSignature           oYellowItalic
hi! link perlSubPrototype        oYellowItalic

" Hash keys
hi! link perlVarSimpleMemberName oBlue
