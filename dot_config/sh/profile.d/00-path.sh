### PATH SH

PATH='/usr/bin:/usr/sbin:/bin:/sbin'

#Local sbin
[ -d '/usr/local/sbin' ]       &&
PATH="/usr/local/sbin:${PATH}" ||
[ ! -d '/usr/local/sbin' ]     ||
return 1

PATH="/usr/local/bin:${PATH}"

# Homebrew
[ -d '/opt/homebrew/' ]			&&
HOMEBREW_PREFIX=/opt/homebrew		&&
PATH="${HOMEBREW_PREFIX}/sbin:${PATH}"	&&
PATH="${HOMEBREW_PREFIX}/bin:${PATH}"	||
[ ! -d '/opt/homebrew/' ]		||
return 1

# Homebrew openjdk
[ -d "${HOMEBREW_PREFIX}/opt/openjdk/bin" ]		&&
PATH="${HOMEBREW_PREFIX}/opt/openjdk/bin:${PATH}"	||
[ ! -d "${HOMEBREW_PREFIX}/opt/openjdk/bin" ]		||
return 1

# Homebrew Node 22
[ -d "${HOMEBREW_PREFIX}/opt/node@22/bin" ]		&&
PATH="${HOMEBREW_PREFIX}/opt/node@22/bin:${PATH}"	||
[ ! -d "${HOMEBREW_PREFIX}/opt/node@22/bin" ]		||
return 1

export PATH

return 0
