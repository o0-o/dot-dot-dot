### ALIASES ZSH

declare -a ALIASES=(
  'cat'   "ccat --bg='dark' --color='auto'" '/dev/null'
)     &&

for COMMAND ALIAS TEST in "${ALIASES[@]}"; do
  # the command used in alias without options/arguments
  ALIAS_COMMAND="$( printf '%s' "${COMMAND}" |
                      cut -d ' ' -f '1'
                  )"                        &&

  # does alias command exist
  command -v "${ALIAS_COMMAND}" &>/dev/null &&
  alias "${COMMAND}"="${ALIAS}"             &&

  # test the alias and unset on failure
  { "${COMMAND}" "${TEST}" &>/dev/null  ||
    unalias "${COMMAND}"
  }                                         ||

  # let alias fail if $ALIAS command isn't available
  ! command -v "${ALIAS_COMMAND}" &>/dev/null
done  ||

return 1

return 0
