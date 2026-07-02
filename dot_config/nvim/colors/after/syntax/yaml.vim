if o#should_abort('yaml')
    finish
endif

hi! link yamlAlias           oGreenItalicUnderline
hi! link yamlAnchor          oMagentaItalic
hi! link yamlBlockMappingKey oCyan
hi! link yamlFlowCollection  oMagenta
hi! link yamlFlowIndicator   Delimiter
hi! link yamlNodeTag         oMagenta
hi! link yamlPlainScalar     oYellow
