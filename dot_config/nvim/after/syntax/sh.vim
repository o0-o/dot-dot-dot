if o#should_abort('bash', 'ksh', 'posix', 'sh')
    finish
endif

hi! link shCommandSub NONE
hi! link shEscape     oRed
hi! link shParen      NONE
hi! link shParenError NONE
