### ALIASES ZSH

declare -a aliases=(
  'cat'   "ccat --bg='dark' --color='auto'" '/dev/null'
  'vi'    'nvim'                            '--version'
  'vim'   'nvim'                            '--version'
)                                             &&

for command alias test in "${aliases[@]}";    do
  # the command used in alias without options/arguments
  alias_command="$( printf '%s' "${command}"  |
                    cut -d ' ' -f '1'
                  )"                          &&

  # does alias command exist
  command -v "${alias_command}"   &>/dev/null &&
  alias "${command}"="${alias}"               &&

  # test the alias and unset on failure
  { "${command}" "${test}"        &>/dev/null ||
    unalias "${command}"
  }                                           ||

  # let alias fail if $ALIAS command isn't available
  ! command -v "${alias_command}" &>/dev/null
done                                          ||

return 1

return 0
