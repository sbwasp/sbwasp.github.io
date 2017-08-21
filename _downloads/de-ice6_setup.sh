#!/usr/bin/env bash

# *******************************************************
# Edit these to match your setup
# *******************************************************
TARGET=192.168.1.104          # ip of de-ice6
SUBNET=192.168.1.0/24         # subnet
KALI=192.168.1.28             # Kali IP
PT=$HOME/pentest/de-ice6      # create working directories here

if [[ $(grep -c de-ice6 /etc/hosts) -eq 0 ]]; then
  echo " add \"$TARGET de-ice6.com\" to /etc/hosts"
fi

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
HOST=de-ice6.com
SUDO=$(which sudo)
[[ "$USER" == "root" ]] && SUDO=

