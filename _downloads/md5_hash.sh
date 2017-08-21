#!/usr/bin/env bash

# Script to show RSA SSH key encryption uses 1 cycle MD5 hash with
#   IV = value from SSH key
#   SALT = first 8 bytes of IV
# We compare the SSH key to the hand-created MD5 encryption version.
# The base-64 cleartext versions of these 2 keys are the same.

# Create the following files
PEM="key"  # rsa public, private keys encrypted by PW
PEM_BINKEY="${PEM}_binkey"  # binary part of key
PEM_CLEAR="${PEM}_clear"  # unencrypted key (w/o header/trailer)
PEM_COMPUTED="${PEM}_computed"  # hand-created key we must prove = PEM key
PEM_COMPUTED_CLEAR="${PEM_COMPUTED}_clear"  # unencrypted hand-created key
PW="12345678"

# generate password-encrypted SSH keys
rm -f ${PEM}*
ssh-keygen -q -t rsa -N "$PW" -f $PEM
# then the binary key (without BEGIN/END)
tail -n +4 $PEM | grep -v 'END ' | base64 -d > $PEM_BINKEY
# then the cleartext key (without BEGIN/END)
openssl rsa -text -in $PEM -passin "pass:$PW" 2>&1 | \
  sed -n -e '/-----BEGIN/,/-----END/p' | \
  egrep -v -- '-----(BEGIN|END)' >  $PEM_CLEAR

# pick out the IV and salt, then compute MD5 key
IV="$(head -n 3 $PEM | tail -n 1 |  cut -d, -f2)"
SALT="${IV:0:16}"
MD5HASH=$(python -c 'import md5;\
    print(md5.new("'$PW'" + "'$SALT'".decode("hex")).hexdigest())')


# Use MD5HASH to decrypt PEM's binary key then base64 encode it
openssl aes-128-cbc -d -iv $IV -K $MD5HASH -in $PEM_BINKEY -out $PEM_COMPUTED
base64 -w 64 $PEM_COMPUTED > $PEM_COMPUTED_CLEAR

# Finally, compare the 2 cleartext keys
diff $PEM_CLEAR $PEM_COMPUTED_CLEAR
if [[ "$?" == "0" ]]; then
  echo "SUCCESS - key plaintext values match"
else
  echo "FAILURE - key plaintext values not equal"
fi

