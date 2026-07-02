#!/usr/bin/env sh

set -eu

: set -o posix
: set -o pipefail

length_minimum="${1-11}"
length_variance="${2-7}"
random_number="$(od -A n -N 1 -t u1 /dev/urandom)"
length="$(( $length_minimum + $random_number % $length_variance ))"

dd if=/dev/urandom bs=1k count=1 2>/dev/null |
  LC_ALL=C tr -dc '\41-\177' |
  cut -c 1-$length
