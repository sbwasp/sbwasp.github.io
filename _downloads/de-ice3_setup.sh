#!/usr/bin/env bash

# *******************************************************
# Edit these to match your setup
# *******************************************************
TARGET1=192.168.2.100         # ip1 of de-ice3
TARGET2=192.168.2.101         # ip2 of de-ice3
SUBNET=192.168.2.0/24         # subnet
KALI=192.168.2.189            # Kali IP
PT=$HOME/pentest/de-ice3      # create working directories here

if [[ $(grep -c de-ice3 /etc/hosts) -eq 0 ]]; then
  echo " add \"$TARGET1 de-ice3.com\" to /etc/hosts"
  echo " add \"$TARGET2 www2.de-ice3.com\" to /etc/hosts"
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
HOST1=de-ice3.com
HOST2=www2.de-ice3.com
SUDO=$(which sudo)
[[ "$USER" == "root" ]] && SUDO=

