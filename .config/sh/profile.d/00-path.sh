### PATH SH

typeset PATH='/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin' &&
export  PATH                                                                &&
unalias -a                                                                  ||

return 1

return 0
