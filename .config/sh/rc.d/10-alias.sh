[ "${TERM}" = alacritty ]                                   &&
alias 'ssh'='TERM=screen-256color ssh'                      ||
[ ! "${TERM}" = alacritty ]

ln  -sf "$(command which nvim)"                 \
        "${XDG_BIN_HOME-$HOME/.local/bin}/vim"  2>/dev/null ||
! command -v nvim                               >/dev/null

ln  -sf "$(command which vim)"                  \
        "${XDG_BIN_HOME-$HOME/.local/bin}/vi"   2>/dev/null ||
! command -v vim                                >/dev/null
