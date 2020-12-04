### TMUX ZSH

## Automatically start tmux with terminal emulator window

# stop if sudo -s
[[ ! "${UID}"  == 0 ]]        &&
[[ ! "${EUID}" == 0 ]]        &&

# stop if already in tmux
[ -z "${TMUX}" ]              &&

# stop if a session was already auto-started
# otherwise tmux will restart on exit
[ -z "${DEFAULT_SESSION}" ]   &&

# stop if in emacs
[ -z "${INSIDE_EMACS}" ]      &&
[ -z "${EMACS}" ]             &&

# stop if in vim
[ -z "${VIM}" ]               &&
{
  # use uid as default session
  DEFAULT_SESSION="${UID-0}"

  # if session doesn't exist, daemonize it
  tmux ls -F '#S'                             2>/dev/null |
  grep -q "^${DEFAULT_SESSION}"                           ||
  tmux new-session -s "${DEFAULT_SESSION}" -d &>/dev/null

  # clean up orphaned sessions
  tmux ls -F "#S#{?session_attached,attached,}" |
  egrep "^${DEFAULT_SESSION}-[0-9]"             |
  grep -v "attached$"                           |
  while read SESSION; do
    tmux kill-session -t "${SESSION}"
  done

  # create new window if other sessions are attached
  tmux ls -F "#S#{?session_attached,attached,}"           |
  egrep -q "^${DEFAULT_SESSION}-[0-9]+attached"           &&
  tmux new-session -t "${DEFAULT_SESSION}" \; new-window  ||

  # otherwise attach to existing window
  tmux new-session -t "${DEFAULT_SESSION}"

  # install/update plugins in background
  "${XDG_CONFIG_HOME:-$HOME/.config}/tmux/plugins/tpm/bin/install_plugins"  &>\
  /dev/null                                                                 &
  "${XDG_CONFIG_HOME:-$HOME/.config}/tmux/plugins/tpm/bin/update_plugins"     \
  'all'                                                                     &>\
  /dev/null                                                                 &
}                             ||
[[ "${UID}"  == 0 ]]          ||
[[ "${EUID}" == 0 ]]          ||
[ ! -z "${TMUX}" ]            ||
[ ! -z "${DEFAULT_SESSION}" ] ||
[ ! -z "${INSIDE_EMACS}" ]    ||
[ ! -z "${EMACS}" ]           ||
[ ! -z "${VIM}" ]             ||

return 1

return 0
