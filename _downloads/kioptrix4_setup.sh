#!/usr/bin/env bash

# *******************************************************
# Edit these to match your setup
# *******************************************************
TARGET=192.168.1.167          # ip of kioptrix4
SUBNET=192.168.1.0/24         # subnet
KALI=192.168.1.104            # Kali IP
PORT=443                      # reverse shell port
PT=$HOME/pentest/kioptrix4    # create working directories here

[[ $(grep -c kioptrix4 /etc/hosts) -eq 0 ]] && \
  echo " add \"$TARGET kioptrix4.com\" to /etc/hosts"

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
HOST=kioptrix4.com
SUDO=$(which sudo)
[[ "$USER" == "root" ]] && SUDO=




