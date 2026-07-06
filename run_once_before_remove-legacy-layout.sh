#!/bin/sh
# One-time migration from the pre-chezmoi layout where $HOME itself was
# a git repo (o0-o/dot-dot-dot before 2026-07). No-op unless ~/.git
# exists, so this is safe on fresh and already-migrated machines.

[ -d "${HOME}/.git" ] || exit 0

# Recovery snapshot of the CURRENT setup before we remove anything:
# .git (full history + submodule gitdirs under .git/modules) plus the
# working-tree copy of every tracked file, so uncommitted edits are
# captured too — a .git-only archive would silently drop them. Bail out
# without deleting if the archive can't be written, so we never destroy
# the legacy layout unless a backup exists.
archive="${HOME}/dot-dot-dot.pre-chezmoi.tar.gz"
{ printf '.git\0'
  git --git-dir="${HOME}/.git" --work-tree="${HOME}" ls-files -z
} | tar -czf "${archive}" -C "${HOME}" --null --files-from=- || {
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
