if o#should_abort('rst')
    finish
endif

hi! link rstComment                             Comment
hi! link rstTransition                          Comment
hi! link rstCodeBlock                           oGreen
hi! link rstInlineLiteral                       oGreen
hi! link rstLiteralBlock                        oGreen
hi! link rstQuotedLiteralBlock                  oGreen
hi! link rstStandaloneHyperlink                 oLink
hi! link rstStrongEmphasis                      oYellowBold
hi! link rstSections                            oBlueBold
hi! link rstEmphasis                            oYellowItalic
hi! link rstDirective                           Keyword
hi! link rstSubstitutionDefinition              Keyword
hi! link rstCitation                            String
hi! link rstExDirective                         String
hi! link rstFootnote                            String
hi! link rstCitationReference                   Tag
hi! link rstFootnoteReference                   Tag
hi! link rstHyperLinkReference                  Tag
hi! link rstHyperlinkTarget                     Tag
hi! link rstInlineInternalTargets               Tag
hi! link rstInterpretedTextOrHyperlinkReference Tag
hi! link rstTodo                                Todo
