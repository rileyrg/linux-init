#!/usr/bin/env bash
# Maintained in linux-init-files.org

logger -t "startup-initfile"  USER-XSESSION
exec dbus-launch --sh-syntax --exit-with-session i3
