#!/usr/bin/bash
# Maintained in linux-init-files.org
# Dont need that as startx will use xinitc anyway if this doesnt exist.
rm ~/.xsession-errors
. /etc/X11/xinit/xinitrc
