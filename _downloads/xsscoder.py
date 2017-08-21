#!/usr/bin/env python3

import argparse

# encode/decoders
def isalphanum(c):
  return( \
    (c >= 'a' and c <= 'z') or \
    (c >= 'A' and c <= 'Z') or \
    (c >= '0' and c <= '9'))

def encoder(prefix, suffix, fmt, c):
  if ord(c) >= 256 or isalphanum(c):
    return(c)
  else:
    return(prefix + format(ord(c), fmt) + suffix)

def make_encoder(prefix, suffix, fmt):
  return lambda c: encoder(prefix, suffix, fmt, c)

css_encoder = make_encoder('\\', ' ', '02X')
js_encoder = make_encoder('\\x', '', '02X')
url_encoder = make_encoder('%', '', '02X')

# allow multiple strings passed
parser = argparse.ArgumentParser()
parser.add_argument("strings", nargs="*", help="strings to encode")
args = parser.parse_args()

# encode each input string
process_me = args.strings
for s in process_me:
  for e in ( css_encoder, js_encoder, url_encoder ):
    out = ''.join(map(e, s))
    print(out)
