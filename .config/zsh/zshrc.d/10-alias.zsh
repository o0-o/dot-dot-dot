### ALIASES ZSH

declare -a alias_assignments=(
  'cat'   "ccat --bg='dark' --color='auto'" 'ccat /dev/null'
  'tmux'  'TERM=screen-256color tmux'       'tmux -V && infocmp screen-256color'
  'tmux'  'TERM=tmux-256color tmux'         'tmux -V && infocmp tmux-256color'
)                                                       &&

for the_alias alias_def alias_test in "${alias_assignments[@]}"; do
  # does alias command pass test
  eval ${alias_test}                  &>/dev/null &&
  alias "${the_alias}"="${alias_def}"             || :
done                                              ||

return 1

return 0
