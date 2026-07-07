#!/bin/sh
# One-time migration from the pre-chezmoi layout where $HOME itself was
# a git repo (o0-o/dot-dot-dot before 2026-07). No-op unless ~/.git
# exists, so this is safe on fresh and already-migrated machines.

[ -d "${HOME}/.git" ] || exit 0

# Recovery snapshot of the CURRENT setup before we remove anything:
# .git (full history + submodule gitdirs under .git/modules) plus the
# working-tree copy of every tracked file, so uncommitted edits are
# captured too — a .git-only archive would silently drop them. Bail out
# without deleting if the snapshot can't be built, so we never destroy
# the legacy layout unless a backup exists.
archive="${HOME}/dot-dot-dot.pre-chezmoi.tar.gz"
tracked="$( mktemp "${TMPDIR:-/tmp}/dotdotdot.XXXXXX" )" || exit 1
list="$( mktemp "${TMPDIR:-/tmp}/dotdotdot.XXXXXX" )" ||
  { rm -f "${tracked}"; exit 1; }
trap 'rm -f "${tracked}" "${list}"' EXIT INT TERM

# List tracked files (relative to $HOME) and check git's own exit status
# here: piping git straight into `| tar` would let a git failure be
# masked by tar succeeding, silently falling back to a .git-only archive.
# core.quotepath=false keeps paths literal; the list is newline-delimited,
# so this assumes no newline in a tracked filename (true for these files).
git -C "${HOME}" -c core.quotepath=false ls-files > "${tracked}" || {
  printf 'legacy migration: git ls-files failed; aborting cleanup\n' >&2
  exit 1
}

# Archive .git plus every tracked path that still exists in the working
# tree. A tracked file deleted from the worktree (rm without git rm) would
# otherwise make tar exit non-zero and abort the whole migration; skip it
# since its content is still recoverable from .git. Keep broken symlinks
# (-L) — tar stores the link itself, not its target.
printf '.git\n' > "${list}"
while IFS= read -r f; do
  { [ -e "${HOME}/${f}" ] || [ -L "${HOME}/${f}" ]; } &&
    printf '%s\n' "${f}"
done < "${tracked}" >> "${list}"

tar -czf "${archive}" -C "${HOME}" -T "${list}" || {
  printf 'legacy migration: failed to write %s; aborting cleanup\n' \
    "${archive}" >&2
  exit 1
}

rm -rf \
  "${HOME}/.git" \
  "${HOME}/.gitmodules" \
  "${HOME}/.LICENSE" \
  "${HOME}/.README.md" \
  "${HOME}/.zshrc" \
  "${HOME}/.zprofile" \
  "${HOME}/.bash_profile" \
  "${HOME}/.config/alacritty" \
  "${HOME}/.config/bash" \
  "${HOME}/.config/gnupg/gpg-9EDC103B64545DB39D2899CCEBB6B88B93D2C86F.pub" \
  "${HOME}/.config/nvim/colors/after" \
  "${HOME}/.config/nvim/lua/o0-o/lazy/golf.lua" \
  "${HOME}/.config/nvim/test.lua" \
  "${HOME}/.config/sh/install_terminfo.sh" \
  "${HOME}/.config/sh/terminfo.src" \
  "${HOME}/.config/tmux/plugins" \
  "${HOME}/.config/zsh/.zshrc" \
  "${HOME}/.config/zsh/zshrc" \
  "${HOME}/.config/zsh/zprofile" \
  "${HOME}/.config/zsh/zshrc.d" \
  "${HOME}/.config/zsh/zprofile.d" \
  "${HOME}/.config/zsh/.zcompdump"* \
  "${HOME}/.config/zsh/omz" \
  "${HOME}/.config/zsh/omz_custom" \
  "${HOME}/.local/share/nvim/site/autoload/plug.vim" \
  "${HOME}/.local/share/themes/Dracula"
