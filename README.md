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
On a new machine:
```
chezmoi init --apply git@github.com:o0-o/dot-dot-dot.git
```
Third-party plugins (oh-my-zsh, powerlevel10k, fast-syntax-highlighting,
tpm, Dracula) are declared in `.chezmoiexternal.toml` and cloned/refreshed
automatically by `chezmoi apply` (weekly refresh).

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
