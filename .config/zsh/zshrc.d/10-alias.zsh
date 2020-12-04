### ALIASES ZSH

declare -a alias_assignments=(

  'cat'   "ccat --bg='dark' --color='auto'" '/dev/null'
  'vi'    'nvim'                            '--version'
  'vim'   'nvim'                            '--version'

)                                                     &&

for the_alias alias_def alias_test in "${alias_assignments[@]}"; do
  # clear pre-existing alias
  unalias "${the_alias}"                  2>/dev/null || :

  # the command used in alias without options/arguments
  alias_def_cmd="$( printf '%s' "${alias_def}"  |
                    cut -d ' ' -f '1'             )"  &&

  # does alias command exist
  command -v "${alias_def_cmd}"           &>/dev/null &&
  alias "${the_alias}"="${alias_def}"                 &&

  # test the alias and unset on failure
  { "${the_alias}" "${alias_test}"        &>/dev/null ||
    unalias "${the_alias}"
  }                                                   ||

  # let alias fail if $alias command isn't available
  ! command -v "${alias_def_cmd}"         &>/dev/null
done                                                  ||

return 1

return 0
