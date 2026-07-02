#!/usr/bin/env sh

set -eu

: set -o posix
: set -o pipefail

dict_length="$(wc -l /usr/share/dict/words | awk '{print $1}')"
random_line="$(($RANDOM$RANDOM % $dict_length ))"
sed -ne "${random_line}{s/[^[:alnum:]]//g;p;}" /usr/share/dict/words |
  tr '[[:upper:]]' '[[:lower:]]' |
  tr -d '\n'
