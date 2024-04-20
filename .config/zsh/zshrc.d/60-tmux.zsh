### TMUX ZSH

## Automatically start tmux with terminal emulator window

# only autostart from alacritty
{ [ "${TERM}" = 'alacritty' ] ||
  [ "${TERM}" = 'xterm-kitty' ]; }  &&

# stop if sudo -s
[ ! "${UID}"  = '0' ]               &&
[ ! "${EUID}" = '0' ]               &&

# stop if already in tmux
[ -z "${TMUX}" ]                    &&

# stop if a session was already auto-started
# otherwise tmux will restart on exit
[ -z "${default_tmux_session}" ]    &&

# stop if in emacs
[ -z "${INSIDE_EMACS}" ]            &&
[ -z "${EMACS}" ]                   &&

# stop if in vim
[ -z "${VIM}" ]                     &&
{
  # use uid as default session
  declare default_tmux_session="${UID-0}"
  export default_tmux_session

  # if no plugins are installed, try installing them before starting the
  # session
  [ $(  ls -d "${XDG_CONFIG_HOME:-$HOME/.config}/tmux/plugins/"*  |
        wc -l                                                    ) -gt '1' ] ||
  "${XDG_CONFIG_HOME:-$HOME/.config}/tmux/plugins/tpm/bin/install_plugins"

  # if session doesn't exist, daemonize it
  tmux ls -F '#S'                                               2>/dev/null |
  grep -q "^${default_tmux_session}"                            ||
  tmux new-session -s "${default_tmux_session}" -d &>/dev/null

  # clean up orphaned sessions
  tmux ls -F "#S#{?session_attached,attached,}" |
  egrep "^${default_tmux_session}-[0-9]"        |
  grep -v "attached$"                           |
  while read SESSION; do
    tmux kill-session -t "${SESSION}"
  done

  # create new window if other sessions are attached
  tmux ls -F "#S#{?session_attached,attached,}"               |
  egrep -q "^${default_tmux_session}(-[0-9]+)?attached"       &&
  tmux new-session -t "${default_tmux_session}" \; new-window ||

  # otherwise attach to existing window
  tmux attach -t "${default_tmux_session}"

  # install/update plugins in background
  ("${XDG_CONFIG_HOME:-$HOME/.config}/tmux/plugins/tpm/bin/install_plugins" &>\
  /dev/null                                                                 &)
  ("${XDG_CONFIG_HOME:-$HOME/.config}/tmux/plugins/tpm/bin/update_plugins"  \
  'all' &>/dev/null                                                         &)

}                                   ||
{ [ "${TERM}" != 'alacritty' ] &&
  [ "${TERM}" != 'xterm-kitty' ]; } ||
[ "${TERM}" = 'alacritty' ]         ||
[ "${UID}"  = '0' ]                 ||
[ "${EUID}" = '0' ]                 ||
[ ! -z "${TMUX}" ]                  ||
[ ! -z "${default_tmux_session}" ]  ||
[ ! -z "${INSIDE_EMACS}" ]          ||
[ ! -z "${EMACS}" ]                 ||
[ ! -z "${VIM}" ]                   ||

return 1

return 0
