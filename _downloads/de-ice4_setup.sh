#!/usr/bin/env bash

# *******************************************************
# Edit these to match your setup
# *******************************************************
TARGET=192.168.1.120          # ip of de-ice4
SUBNET=192.168.1.0/24         # subnet
KALI=192.168.1.100            # Kali IP
PT=$HOME/pentest/de-ice4      # create working directories here

if [[ $(grep -c de-ice4 /etc/hosts) -eq 0 ]]; then
  echo " add \"$TARGET de-ice4.com\" to /etc/hosts"
fi

# *******************************************************
# Maybe edit these
# *******************************************************
# Create some directories
TOOLS=exploit,nmap,sqlmap
eval mkdir -p $PT/{$TOOLS}
TARGETS=targets.txt

# *******************************************************
# Don't edit these
# *******************************************************
HOST=de-ice4.com
SUDO=$(which sudo)
[[ "$USER" == "root" ]] && SUDO=

