gpgconf --version 1>/dev/null 2>&1                        &&
{ GPG_TTY="$( tty )"                                        &&
  SSH_AUTH_SOCK=$(  gpgconf --list-dirs agent-ssh-socket  ) &&
  export  GPG_TTY SSH_AUTH_SOCK                             &&

  gpgconf --kill gpg-agent                                  &&
  gpgconf --launch gpg-agent                                ||

  return  1
} ||
! gpgconf --version 1>/dev/null 2>&1

return  0
