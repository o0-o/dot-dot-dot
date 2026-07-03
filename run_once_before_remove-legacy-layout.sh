#!/bin/sh
# One-time migration from the pre-chezmoi layout where $HOME itself was
# a git repo (o0-o/dot-dot-dot before 2026-07). No-op unless ~/.git
# exists, so this is safe on fresh and already-migrated machines.

[ -d "${HOME}/.git" ] || exit 0

# keep a local recovery copy of the old repo before removing it
tar -czf "${HOME}/dot-dot-dot.git.pre-chezmoi.tar.gz" -C "${HOME}" .git

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
