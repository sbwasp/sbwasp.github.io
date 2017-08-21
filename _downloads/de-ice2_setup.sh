#!/usr/bin/env bash

# *******************************************************
# Edit these to match your setup
# *******************************************************
TARGET=192.168.1.110          # ip of de-ice2
SUBNET=192.168.1.0/24         # subnet
KALI=192.168.1.28             # Kali IP
PT=$HOME/pentest/de-ice2      # create working directories here

[[ $(grep -c de-ice2 /etc/hosts) -eq 0 ]] && \
  echo " add \"$TARGET de-ice2.com\" to /etc/hosts"

# *******************************************************
# Maybe edit these
# *******************************************************
# Create some directories
TOOLS=exploit,nmap
eval mkdir -p $PT/{$TOOLS}
TARGETS=targets.txt

# *******************************************************
# Don't edit these
# *******************************************************
HOST=de-ice2.com
SUDO=$(which sudo)
[[ "$USER" == "root" ]] && SUDO=

