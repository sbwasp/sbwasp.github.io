#!/usr/bin/env python3

# % encode a full URL, preserving equal and ampersand in the query part

import argparse
import urllib.parse

# allow multiple strings passed
parser = argparse.ArgumentParser()
parser.add_argument("strings", nargs="*", help="strings to % encode")
args = parser.parse_args()

# % encode each input string
process_me = args.strings
for s in process_me:
    url = urllib.parse.urlsplit(s)
    ql = urllib.parse.parse_qsl(url.query)
    qs = urllib.parse.urlencode(ql,doseq=True)
    sp = (url.scheme, url.netloc, urllib.parse.quote(url.path), \
        qs, url.fragment)
    out = urllib.parse.urlunsplit(sp)
    print(out)

