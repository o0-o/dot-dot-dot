# /etc/zshrc sets history, we can't set it in zprofile
setopt SHARE_HISTORY                                                    &&

# Separate history by tty
declare HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/zsh_history" &&
install -m '700' -d "${HISTFILE%/*}"                                    &&

export HISTFILE                                                         ||

return 1

# Use local history for up/down arrows, but keep global history otherwise
# Shamelessly copied from: superuser.com/questions/446594
up-line-or-local-history() {
    zle set-local-history 1
    zle up-line-or-history
    zle set-local-history 0
}

down-line-or-local-history() {
    zle set-local-history 1
    zle down-line-or-history
    zle set-local-history 0
}

bindkey "^[OA"  up-line-or-local-history    &&
bindkey "^[OB"  down-line-or-local-history  &&
zle -N up-line-or-local-history             &&
zle -N down-line-or-local-history           ||

return 1

return 0
