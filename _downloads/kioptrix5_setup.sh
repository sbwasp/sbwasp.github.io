#!/usr/bin/env bash

# *******************************************************
# Edit these to match your setup
# *******************************************************
TARGET=192.168.1.159          # ip of kioptrix5
SUBNET=192.168.1.0/24         # subnet
KALI=192.168.1.104            # Kali IP
PORT=4444                     # reverse shell port
PORT2=4445                    # nc port for file upload
PT=$HOME/pentest/kioptrix5    # create working directories here

[[ $(grep -c kioptrix5 /etc/hosts) -eq 0 ]] && \
  echo " add \"$TARGET kioptrix5.com\" to /etc/hosts"

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
HOST=kioptrix5.com
SUDO=$(which sudo)
[[ "$USER" == "root" ]] && SUDO=

