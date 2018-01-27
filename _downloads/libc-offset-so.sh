#!/usr/bin/env bash

if [[ $# != "3" ]]; then
  echo "$0 LIBC FUNC1 FUNC2"
  exit
fi

LIB="$1"
FUNC1="$2"
FUNC2="$3"

set $(objdump -T $LIB | grep " __libc_start_main$" | head -n 1)
printf -v Olibc "0x%x" 0x$1
set $(objdump -T $LIB | grep " $FUNC1$" | head -n 1)
printf -v O1 "0x%x" 0x$1
set $(objdump -T $LIB | grep " $FUNC2$" | head -n 1)
printf -v O2 "0x%x" 0x$1
printf -v offset1 "0x%x\n" $(( O1 - O2 ))
printf -v offset2 "0x%x\n" $(( O2 - Olibc ))
echo $FUNC1 = $O1
echo $FUNC2 = $O2
echo offset $FUNC1 - $FUNC2 = $offset1
echo offset $FUNC2 - libc = $offset2
