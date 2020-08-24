# enforce xdg directories
declare ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"               &&
declare ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"           &&
declare HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/zsh_history"   &&

install -m '700' -d "${ZDOTDIR}" "${ZSH_CACHE_DIR}" "${HISTFILE%/*}"  &&

export ZDOTDIR ZSH_CACHE_DIR HISTFILE                                 ||

return 1

return 0
