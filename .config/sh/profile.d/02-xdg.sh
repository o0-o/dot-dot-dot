### XDG SH

## XDG Spec Parameters
# use typeset for portability
# formula: set dir param, create it if necessary

typeset XDG_DATA_HOME="${HOME}/.local/share"  &&
{ [ -d "${XDG_DATA_HOME}" ]                   ||
  install -m  '700'                           \
          -d  "${XDG_DATA_HOME}"
}                                             &&

typeset XDG_CONFIG_HOME="${HOME}/.config" &&
{ [ -d "${XDG_CONFIG_HOME}" ]             ||
  install -m  '700'                       \
          -d  "${XDG_CONFIG_HOME}"
}                                         &&

# assume these exist
typeset XDG_DATA_DIRS='/usr/local/share:/usr/share' &&

# use /etc/xdg or /usr/local/etc/xdg if available
# otherwise use $XDG_DATA_HOME/xdg
[ -d '/etc/xdg' ]                                   &&
typeset XDG_CONFIG_DIRS='/etc/xdg'                  ||
{ [ -d '/usr/local/etc/xdg/' ]                      &&
  typeset XDF_CONFIG_DIRS='/usr/local/etc/xdg'      ||
  { typeset XDF_CONFIG_DIRS="${XDG_DATA_HOME}/xdg"  &&
    { [ -d "${XDG_DATA_HOME}/xdg" ]                 ||
      install -m  '700'                             \
              -d  "${XDG_DATA_HOME}/xdg"
    }
  }
}                                                   &&

typeset XDG_CACHE_HOME="${HOME}/.cache" &&
{ [ -d "${XDG_CACHE_HOME}" ]            ||
  install -m  '700'                     \
          -d  "${XDG_CACHE_HOME}"
}                                       &&

typeset XDG_RUNTIME_DIR="${HOME}/.run"  &&
{ [ -d "${XDG_RUNTIME_DIR}" ]           ||
  install -m  '700'                     \
          -d  "${XDG_RUNTIME_DIR}"
}                                       &&

## XDG Derivatives

# bin
typeset XDG_BIN_HOME="${HOME}/.local/bin" &&
{ [ -d "${XDG_BIN_HOME}" ]                ||
  install -m '700'                        \
          -d  "${XDG_BIN_HOME}"
}                                         &&

# add bin to beginning of $PATH unless already present
{ printf '%s' "${PATH}"                         |
  egrep -q "${XDG_BIN_HOME}:|:${XDG_BIN_HOME}"  ||
  typeset PATH="${XDG_BIN_HOME}:${PATH}"
}                                               &&

# compatibility symlinks if other common user binary directories exist
for compat_bin_dir in "${HOME}/bin"; do

  # stop if $compat_bin_dir doesn't exist or isn't a directory
  [ -d "${compat_bin_dir}" ]                                                &&

  # stop if $compat_bin_dir is already a symlink
  [ ! -L "${compat_bin_dir}" ]                                              &&

  # stop if $compat_bin_dir isn't empty
  [ ! "$(ls -A "${compat_bin_dir}")" ]                                      &&

  # stop if $XDG_BIN_HOME is already equivalent $compat_bin_dir
  [[ ! "$(cd "${XDG_BIN_HOME}"; pwd)" = "$(cd "${compat_bin_dir}"; pwd)" ]] &&

  # replace $compat_bin_dir with symlink to $XDG_BIN_HOME
  rm -r "${compat_bin_dir}"                                                 &&
  ln -s "${XDG_BIN_HOME}"   "${compat_bin_dir}"                             ||
  : # conditions were not met for symlink creation

done                                                                  &&

export  XDG_CONFIG_HOME XDG_DATA_DIRS XDG_CONFIG_DIRS XDG_CACHE_HOME  \
        XDG_RUNTIME_DIR PATH                                          ||

return 1

return 0
