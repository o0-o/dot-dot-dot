### PATH SH

# prepend a directory to PATH if it exists and isn't already present
path_prepend() {
  [ -d "${1}" ] || return 0
  # move to the front (dedup): drop any existing occurrence, then prepend.
  # macOS path_helper (/etc/zprofile) re-adds system + /etc/paths.d dirs
  # ahead of ours on every login shell, so a skip-if-present prepend would
  # strand Homebrew at the tail — actively move it forward instead.
  case ":${PATH}:" in
    *":${1}:"*) PATH="$(printf '%s' ":${PATH}:" | sed -e "s|:${1}:|:|g" -e 's|^:*||' -e 's|:*$||')" ;;
  esac
  PATH="${1}${PATH:+:${PATH}}"
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
