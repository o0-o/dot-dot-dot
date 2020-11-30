### PATH SH

typeset PATH='/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin' &&
{ # Homebrew openjdk
  [   -d '/usr/local/opt/openjdk/bin' ]                                     &&
  typeset PATH="/usr/local/opt/openjdk/bin:${PATH}"                         ||
  [ ! -d '/usr/local/opt/openjdk/bin' ]
}                                                                           &&
export  PATH                                                                &&
unalias -a                                                                  ||

return 1

return 0
