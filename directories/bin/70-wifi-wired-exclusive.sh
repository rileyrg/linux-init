#!/usr/bin/env bash
#Maintained in linux-config.org
# https://askubuntu.com/a/1272865/232407
export LC_ALL=C

# This dispatcher script makes Wi-Fi mutually exclusive with wired networking. When a wired
#    interface is connected, Wi-Fi will be set to airplane mode (rfkilled). When the wired
#    interface is disconnected, Wi-Fi will be turned back on. Name this script e.g.
#    70-wifi-wired-exclusive.sh and put it into /etc/NetworkManager/dispatcher.d/ directory.
#    See NetworkManager(8) manual page for more information about NetworkManager dispatcher
#    scripts.

if [ "$2" = "up" ]; then
    enable-disable-wifi
fi

if [ "$2" = "down" ]; then
    enable-disable-wifi
fi
