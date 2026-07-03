# no-op when gpg is not installed (e.g. work machines) or the shell
# has no tty (scripts, scp, IDE shells) — tty would fail either way
{ gpgconf --version 1>/dev/null 2>&1  &&
  [ -t 0 ]; }                         ||
return  0

GPG_TTY="$( tty )"                                        &&
SSH_AUTH_SOCK=$(  gpgconf --list-dirs agent-ssh-socket  ) &&
export  GPG_TTY SSH_AUTH_SOCK                             &&

gpgconf --kill gpg-agent                                  &&
gpgconf --launch gpg-agent                                ||

return  1

return  0
