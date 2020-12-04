### ALIASES ZSH

declare -a alias_assignments=(

  'cat'   "ccat --bg='dark' --color='auto'" '/dev/null'
  'vi'    'nvim'                            '--version'
  'vim'   'nvim'                            '--version'

)                                                       &&

for the_alias alias_def alias_test in "${alias_assignments[@]}"; do

  # does alias command pass test
  "${alias_def}" ${alias_test}        &>/dev/null &&
  alias "${the_alias}"="${alias_def}"             || :

done                                              ||

return 1

return 0
