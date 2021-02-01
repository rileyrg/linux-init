#!/usr/bin/bash
# Maintained in linux-init-files.org
# /etc/acpi/actions/user-powerstate
. /usr/share/acpi-support/power-funcs
. /usr/share/acpi-support/policy-funcs
getState
echo "export POWERSTATE=${STATE}"  > /tmp/user-acpi-powerstate
export POWERSTATE=$STATE
