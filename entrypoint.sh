#!/bin/bash

# This won't be executed if keys already exist (i.e. from a volume)
ssh-keygen -A

# Copy authorized keys from ENV variable
echo "$AUTHORIZED_KEYS" >$AUTHORIZED_KEYS_FILE

# Prevent the user from changing directory upwards
#sed -i -e '/chrootpath/d' /etc/rssh.conf
#echo "chrootpath = $DATADIR" >> /etc/rssh.conf

usermod --home "$DATADIR" --shell /usr/bin/rssh "$OWNER"
# Chown data folder (if mounted as a volume for the first time)
chown "$OWNER" "$DATADIR"

# Run sshd on container start
exec /usr/sbin/sshd -D -e
