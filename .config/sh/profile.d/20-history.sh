# Less
# Enforce xdg
typeset LESSHISTFILE="${XDG_DATA_HOME:-$HOME/.local}/less/lesshst"  &&
install -m '700' -d \
  "${LESSHISTFILE%/*}"                                              &&

export LESSHISTFILE                                                 ||

return 1

return 0
