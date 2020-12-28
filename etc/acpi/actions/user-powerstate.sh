#! /usr/bin/bash
# /etc/acpi/actions/user-powerstate
. /usr/share/acpi-support/power-funcs
. /usr/share/acpi-support/policy-funcs
getState
echo "export POWERSTATE=${STATE}"  > /tmp/user-acpi-powerstate
export POWERSTATE=$STATE
