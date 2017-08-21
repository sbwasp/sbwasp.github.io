#!/usr/bin/env bash

# *******************************************************
# Edit these to match your setup
# *******************************************************
TARGET=192.168.1.102          # ip of kioptrix3
SUBNET=192.168.1.0/24         # subnet
KALI=192.168.1.104            # Kali IP
PORT=4444                     # reverse shell port
PT=$HOME/pentest/kioptrix3    # create working directories here

[[ $(grep -c kioptrix3 /etc/hosts) -eq 0 ]] && \
  echo " add \"$TARGET kioptrix3.com\" to /etc/hosts"

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
HOST=kioptrix3.com
SUDO=$(which sudo)
[[ "$USER" == "root" ]] && SUDO=




