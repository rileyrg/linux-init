# Maintained in linux-config.org
logger -t "startup-initfile"  ZPROFILE
if ! type "sway-www" > /dev/null; then
    if [ -f ~/.profile ]; then
        # install foobar here
        emulate sh -c '. ~/.profile'
    fi
fi
