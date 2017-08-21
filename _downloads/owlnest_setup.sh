#!/usr/bin/env bash

# *******************************************************
# Edit these to match your setup
# *******************************************************
TARGET=192.168.1.102          # ip of owlnest
SUBNET=192.168.1.0/24         # subnet
KALI=192.168.1.28             # Kali IP
PORT=4444                     # reverse shell port
PT=$HOME/pentest/owlnest      # create working directories here

if [[ $(grep -c owlnest /etc/hosts) -eq 0 ]]; then
  echo " add \"$TARGET owlnest.com\" to /etc/hosts"
fi

# *******************************************************
# Maybe edit these
# *******************************************************
# Create some directories
TOOLS=exploit,nmap,spider
eval mkdir -p $PT/{$TOOLS}
COOKIES=cookies.txt
TARGETS=targets.txt

# *******************************************************
# Don't edit these
# *******************************************************
HOST=owlnest.com
SUDO=$(which sudo)
[[ "$USER" == "root" ]] && SUDO=

