#!/usr/bin/env bash

# Compute offset(FUNC1) - offset(FUNC2)
[[ $# != 3 ]] && { echo "Usage: $0 PROG FUNC1 FUNC2"; exit; }
PROG=$1
FUNC1=$2
FUNC2=$3

# Get the libc filename
set  $(ldd $PROG | grep 'libc.so' | head -n 1)
LIB=$3
# From there, get each function offset
set $(objdump -T $LIB | grep " $FUNC1$" | head -n 1)
printf -v O1 "0x%x" 0x$1
set $(objdump -T $LIB | grep " $FUNC2$" | head -n 1)
printf -v O2 "0x%x" 0x$1

# Output the offset difference in hex
printf "0x%x\n" $(( O1 - O2 ))
