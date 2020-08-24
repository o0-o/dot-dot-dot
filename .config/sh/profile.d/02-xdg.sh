### XDG SH

## XDG Spec Parameters
# use typeset for portability
# formula: set dir param, create it if necessary

typeset XDG_DATA_HOME="${HOME}/.local/share"                      &&
{ [ -d "${XDG_DATA_HOME}" ] ||
  install -m 700 -d \
    "${XDG_DATA_HOME}"
}                                                                 &&

typeset XDG_CONFIG_HOME="${HOME}/.config"                         &&
{ [ -d "${XDG_CONFIG_HOME}" ] ||
  install -m 700 -d \
    "${XDG_CONFIG_HOME}"
}                                                                 &&

# assume these exist
typeset XDG_DATA_DIRS='/usr/local/share:/usr/share'               &&

# use /etc/xdg or /usr/local/etc/xdg if available
# otherwise use $XDG_DATA_HOME/xdg
[ -d '/etc/xdg' ]                                                 &&
typeset XDG_CONFIG_DIRS='/etc/xdg'  ||
{ [ -d '/usr/local/etc/xdg/' ]                  &&
  typeset XDF_CONFIG_DIRS='/usr/local/etc/xdg'  ||
  { typeset XDF_CONFIG_DIRS="${XDG_DATA_HOME}/xdg"  &&
    { [ -d "${XDG_DATA_HOME}/xdg" ]                 ||
      install -m 700 -d \
        "${XDG_DATA_HOME}/xdg"
    }
  }
}                                                                 &&

typeset XDG_CACHE_HOME="${HOME}/.cache"                           &&
{ [ -d "${XDG_CACHE_HOME}" ] ||
  install -m 700 -d \
    "${XDG_CACHE_HOME}"
}                                                                 &&

typeset XDG_RUNTIME_DIR="${HOME}/.run"  &&
{ [ -d "${XDG_RUNTIME_DIR}" ] ||
  install -m 700 -d \
    "${XDG_RUNTIME_DIR}"
}                                                                 &&

export  XDG_CONFIG_HOME XDG_DATA_DIRS XDG_CONFIG_DIRS \
        XDG_CACHE_HOME XDG_RUNTIME_DIR                            &&

## XDG Derivatives

# bin
typeset XDG_BIN_HOME="${HOME}/.local/bin"                         &&
{ [ -d "${XDG_BIN_HOME}" ] ||
  install -m 700 -d \
    "${XDG_BIN_HOME}"
}                                                                 &&

# add bin to beginning of $PATH unless already present
{ printf '%s' "${PATH}" |
    egrep -q "${XDG_BIN_HOME}:|:${XDG_BIN_HOME}"  ||
  typeset PATH="${XDG_BIN_HOME}:${PATH}"
}                                                                 &&

# compatibility symlinks if other common user binary directories exist
for COMPAT_BIN_DIR in "${HOME}/bin" "${HOME}/Applications"; do

  # stop if $COMPAT_BIN_DIR doesn't exist or isn't a directory
  [ -d "${COMPAT_BIN_DIR}" ]                                                  &&

  # stop if $COMPAT_BIN_DIR is already a symlink
  [ ! -L "${COMPAT_BIN_DIR}" ]                                                &&

  # stop if $COMPAT_BIN_DIR isn't empty
  [ ! "$(ls -A "${COMPAT_BIN_DIR}")" ]                                        &&

  # stop if $XDG_BIN_HOME is already equivalent $COMPAT_BIN_DIR
  [[ ! "$(cd "${XDG_BIN_HOME}"; pwd)" == "$(cd "${COMPAT_BIN_DIR}"; pwd)" ]]  &&

  # replace $COMPAT_BIN_DIR with symlink to $XDG_BIN_HOME
  rm -r "${COMPAT_BIN_DIR}"                                                   &&
  ln -s "${XDG_BIN_HOME}" \
        "${COMPAT_BIN_DIR}"                                                   ||
  : # conditions were not met for symlink creation

done                                                              &&

# enforce xdg
typeset LESSHISTFILE="${XDG_DATA_HOME:-$HOME/.local}/less/lesshst" &&
install -m '700' -d \
  "${LESSHISTFILE%/*}"                                            &&

export PATH LESSHISTFILE                                          ||

return 1

return 0
