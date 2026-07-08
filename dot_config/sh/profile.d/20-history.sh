# keep interactive-tool histories out of ~ (XDG state, per spec)
state="${XDG_STATE_HOME:-$HOME/.local/state}"

# less
LESSHISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/less/lesshst"

# python REPL (PYTHON_HISTORY: CPython >= 3.13)
PYTHON_HISTORY="${state}/python/history"

# sqlite3 CLI
SQLITE_HISTORY="${state}/sqlite/history"

for hist in "${LESSHISTFILE}" "${PYTHON_HISTORY}" "${SQLITE_HISTORY}"; do
  [ -d "${hist%/*}" ] || install -m '700' -d "${hist%/*}"
done
unset hist state

export LESSHISTFILE PYTHON_HISTORY SQLITE_HISTORY
