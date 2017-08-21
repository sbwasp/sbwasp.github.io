#!/usr/bin/env bash

# *******************************************************
# Edit these to match your setup
# *******************************************************
TARGET=192.168.1.100          # ip of de-ice1
SUBNET=192.168.1.0/24         # subnet
KALI=192.168.1.28             # Kali IP
PT=$HOME/pentest/de-ice1      # create working directories here

[[ $(grep -c de-ice1 /etc/hosts) -eq 0 ]] && \
  echo " add \"$TARGET de-ice1.com\" to /etc/hosts"

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
HOST=de-ice1.com
SUDO=$(which sudo)
[[ "$USER" == "root" ]] && SUDO=

