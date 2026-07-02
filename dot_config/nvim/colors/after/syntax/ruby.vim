if o#should_abort('ruby')
    finish
endif

if ! exists('g:ruby_operators')
    let g:ruby_operators=1
endif

hi! link rubyBlockArgument          oYellowItalic
hi! link rubyBlockParameter         oYellowItalic
hi! link rubyCurlyBlock             oMagenta
hi! link rubyGlobalVariable         oBlue
hi! link rubyInstanceVariable       oBlueItalic
hi! link rubyInterpolationDelimiter oMagenta
hi! link rubyRegexpDelimiter        oRed
hi! link rubyStringDelimiter        oYellow
