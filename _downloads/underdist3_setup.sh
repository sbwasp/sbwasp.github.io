#!/usr/bin/env bash

# *******************************************************
# Edit these to match your setup
# *******************************************************
TARGET=192.168.1.100          # ip of underdist3
SUBNET=192.168.1.0/24         # subnet
KALI=192.168.1.104            # Kali IP
PORT=4444                     # reverse shell port
PT=$HOME/pentest/underdist3   # create working directories here

[[ $(grep -c underdist3 /etc/hosts) -eq 0 ]] && \
  echo " add \"$TARGET underdist3.com\" to /etc/hosts"

# *******************************************************
# Maybe edit these
# *******************************************************
# Create some directories
TOOLS=exploit,nmap,spider
eval mkdir -p $PT/{$TOOLS}
TARGETS=targets.txt

# *******************************************************
# Don't edit these
# *******************************************************
HOST=underdist3.com
SUDO=$(which sudo)
[[ "$USER" == "root" ]] && SUDO=

