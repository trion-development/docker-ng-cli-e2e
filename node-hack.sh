#!/bin/sh
echo "calling node: ${@}"
export LD_PRELOAD=/usr/local/lib/intercept-execve.so
/usr/local/bin/node "${@}"
