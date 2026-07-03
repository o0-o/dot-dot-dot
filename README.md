# dot-dot-dot
My dot files, managed with [chezmoi](https://www.chezmoi.io).

# Requires
* chezmoi
* zsh
* tmux
* neovim
* MesloLGSDZ Nerd Font Mono
* gnupg + YubiKey (only for encrypted files)

# Installation
Idempotent bootstrap for a stock system (macOS: install Homebrew first,
which provides git):
```sh
command -v chezmoi >/dev/null 2>&1  ||
[ -x "${HOME}/.local/bin/chezmoi" ] ||
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "${HOME}/.local/bin"

"$( command -v chezmoi || printf '%s/.local/bin/chezmoi' "${HOME}" )" \
  init --apply https://github.com/o0-o/dot-dot-dot.git
```
Machines still on the legacy home-as-git-repo layout migrate themselves:
a run_once script archives the old repo to
`~/dot-dot-dot.git.pre-chezmoi.tar.gz` and removes the legacy files
before the first apply.

Third-party plugins (oh-my-zsh, powerlevel10k, fast-syntax-highlighting,
tpm) are declared in `.chezmoiexternal.toml` and cloned/refreshed
automatically by `chezmoi apply` (weekly refresh).

To push changes from a machine, switch the source remote to ssh:
```
chezmoi cd && git remote set-url origin git@github.com:o0-o/dot-dot-dot.git
```

# Usage
```
chezmoi edit ~/.config/zsh/zshrc   # edit source, then chezmoi apply
chezmoi re-add                     # pull in edits made directly in ~
chezmoi diff                       # preview pending changes
chezmoi apply                      # converge ~ to source state
chezmoi add ~/.config/foo          # start managing a new file
chezmoi add --encrypt ~/.foo       # store gpg-encrypted (YubiKey)
chezmoi cd                         # drop into the source git repo
chezmoi update                     # pull remote + apply (other machines)
```
