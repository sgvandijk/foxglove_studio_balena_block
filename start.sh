#!/bin/bash

# this allows chromium sandbox to run, see https://github.com/balena-os/meta-balena/issues/2319
sysctl -w user.max_user_namespaces=10000

# Run balena base image entrypoint script
/usr/bin/entry.sh echo "Running balena base image entrypoint..."

export DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket

sed -i -e 's/console/anybody/g' /etc/X11/Xwrapper.config
echo "needs_root_rights=yes" >> /etc/X11/Xwrapper.config
dpkg-reconfigure xserver-xorg-legacy

# check if display number envar was set
if [[ -z "$DISPLAY_NUM" ]]
  then
    export DISPLAY_NUM=0
fi

# We can't maintain the environment with su, because we are logging in to a new session
# so we need to manually pass in the environment variables to maintain, in a whitelist.
# This gets the current environment, as a comma-separated string.
environment=$(env | grep -v -w '_' | awk -F= '{ st = index($0,"=");print substr($1,0,st) ","}' | tr -d "\n")
# Remove the last comma.
environment="${environment::-1}"

# Launch Foxglove Studio:
# * Whitelist the environment variables found above
# * Run `startx.sh` in an X session with `startx`
# * Start the shell as a login shell with an environment similar to a real login
# * Run as the `foxglove` user
exec su \
    --whitelist-environment=$environment \
    --command="export DISPLAY=:$DISPLAY_NUM && startx /startx.sh" \
    --login \
    foxglove

balena-idle
