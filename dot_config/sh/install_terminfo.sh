#!/usr/bin/env sh

set -eu

infocmp -x tmux-256color > /dev/null &&
/usr/bin/tic -xe alacritty-direct,tmux-256color terminfo.src 2> /dev/null
