### XDG SH
# https://specifications.freedesktop.org/basedir-spec/

XDG_DATA_HOME="${HOME}/.local/share"
XDG_CONFIG_HOME="${HOME}/.config"
XDG_CACHE_HOME="${HOME}/.cache"
XDG_STATE_HOME="${HOME}/.local/state"
XDG_RUNTIME_DIR="${HOME}/.run"
XDG_BIN_HOME="${HOME}/.local/bin"
XDG_DATA_DIRS='/usr/local/share:/usr/share'

if [ -d '/etc/xdg' ]; then
  XDG_CONFIG_DIRS='/etc/xdg'
elif [ -d '/usr/local/etc/xdg' ]; then
  XDG_CONFIG_DIRS='/usr/local/etc/xdg'
else
  XDG_CONFIG_DIRS="${XDG_DATA_HOME}/xdg"
fi

for xdg_dir in "${XDG_DATA_HOME}" "${XDG_CONFIG_HOME}" \
               "${XDG_CACHE_HOME}" "${XDG_STATE_HOME}" \
               "${XDG_RUNTIME_DIR}" "${XDG_BIN_HOME}"; do
  [ -d "${xdg_dir}" ] || install -m '700' -d "${xdg_dir}"
done
unset xdg_dir

# user bin first in PATH
case ":${PATH}:" in
  *":${XDG_BIN_HOME}:"*) ;;
  *) PATH="${XDG_BIN_HOME}:${PATH}" ;;
esac

export XDG_DATA_HOME XDG_CONFIG_HOME XDG_DATA_DIRS XDG_CONFIG_DIRS \
       XDG_CACHE_HOME XDG_STATE_HOME XDG_RUNTIME_DIR XDG_BIN_HOME PATH
