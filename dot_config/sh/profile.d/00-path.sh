### PATH SH

# prepend a directory to PATH if it exists and isn't already present
path_prepend() {
  [ -d "${1}" ] || return 0
  case ":${PATH}:" in
    *":${1}:"*) ;;
    *) PATH="${1}:${PATH}" ;;
  esac
}

path_prepend '/usr/local/sbin'
path_prepend '/usr/local/bin'

# Homebrew (and kegs that don't link into the default prefix)
if [ -d '/opt/homebrew' ]; then
  HOMEBREW_PREFIX='/opt/homebrew'
  export HOMEBREW_PREFIX
  path_prepend "${HOMEBREW_PREFIX}/sbin"
  path_prepend "${HOMEBREW_PREFIX}/bin"
  path_prepend "${HOMEBREW_PREFIX}/opt/openjdk/bin"
  path_prepend "${HOMEBREW_PREFIX}/opt/node@22/bin"
fi

unset -f path_prepend
export PATH
