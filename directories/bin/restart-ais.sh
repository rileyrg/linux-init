#!/usr/bin/env bash
#Maintained in https://github.com/rileyrg/linux-init
if pgrep AIS-catcher >/dev/null; then
 kill -9 `pgrep AIS`
fi
/usr/share/aiscatcher/start-ais.sh > /dev/null 2>&1 &
