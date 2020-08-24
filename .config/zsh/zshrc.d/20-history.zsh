# /etc/zshrc sets history, we can't set it in zprofile
declare HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/zsh_history" &&
install -m '700' -d "${HISTFILE%/*}"                                &&

export HISTFILE                                                     ||

return 1

return 0
