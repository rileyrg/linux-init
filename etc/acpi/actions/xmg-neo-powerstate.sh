#!/usr/bin/env bash
# Maintained in linux-config.org
# /etc/acpi/actions/xmg-neo-powerstate
. /usr/share/acpi-support/power-funcs
. /usr/share/acpi-support/policy-funcs
getState
echo $( [ $STATE ="AC" ] && echo 0 || echo 1 ) > /sys/class/leds/qc71_laptop::lightbar/brightness
