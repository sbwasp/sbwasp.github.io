#!/usr/bin/env bash

# *******************************************************
# Edit these to match your setup
# *******************************************************
TARGET=192.168.1.20           # ip of de-ice5
SUBNET=192.168.1.0/24         # subnet
KALI=192.168.1.100            # Kali IP
PT=$HOME/pentest/de-ice5      # create working directories here

if [[ $(grep -c de-ice5 /etc/hosts) -eq 0 ]]; then
  echo " add \"$TARGET de-ice5.com\" to /etc/hosts"
fi

# *******************************************************
# Maybe edit these
# *******************************************************
# Create some directories
TOOLS=exploit,nmap,spider,sqlmap
eval mkdir -p $PT/{$TOOLS}
TARGETS=targets.txt

# *******************************************************
# Don't edit these
# *******************************************************
HOST=de-ice5.com
SUDO=$(which sudo)
[[ "$USER" == "root" ]] && SUDO=

