# enforce xdg directories
declare ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"             &&
declare HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/zsh_history" &&

install -m '700' -d "${ZDOTDIR}" "${HISTFILE%/*}"                   &&

export ZDOTDIR HISTFILE                                             ||

return 1

return 0
