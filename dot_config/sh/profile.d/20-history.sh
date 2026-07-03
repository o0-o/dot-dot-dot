# less: keep history under XDG data dir
LESSHISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/less/lesshst"
[ -d "${LESSHISTFILE%/*}" ] || install -m '700' -d "${LESSHISTFILE%/*}"
export LESSHISTFILE
