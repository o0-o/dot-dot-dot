#!/bin/sh
# Bootstrap Doom Emacs (one-time): runs after the doomemacs external clone
# and the Brewfile hook have provided ~/.config/emacs and emacs itself.
# 'doom install' is idempotent; --force auto-accepts its prompts.
# Skips quietly if emacs isn't installed yet or Doom is already set up —
# run '~/.config/emacs/bin/doom install' manually in that case (run_once
# will not fire again on this machine once it has succeeded).
set -eu
PATH="/opt/homebrew/bin:/opt/homebrew/sbin:${PATH}"
doom="${HOME}/.config/emacs/bin/doom"
[ -x "${doom}" ] || exit 0
command -v emacs >/dev/null 2>&1 || exit 0
[ -e "${HOME}/.config/emacs/.local" ] && exit 0
"${doom}" install --force
