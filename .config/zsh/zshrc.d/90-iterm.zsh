### ITERM ZSH

test -e "${HOME}/.iterm2_shell_integration.zsh"   &&
source "${HOME}/.iterm2_shell_integration.zsh"    ||
! test -e "${HOME}/.iterm2_shell_integration.zsh" ||

return 1

return 0
