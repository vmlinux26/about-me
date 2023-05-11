#!/bin/bash

VAR0=$(cat /etc/os-release | grep -w ID_LIKE | cut -f2 -d= |\
    tr -d [=\"=] | cut -f1 -d' ')
VAR0="${VAR0:=$(cat /etc/os-release | grep -w ID | cut -f2 -d= |\
    tr -d [=\"=])}"
echo $VAR0

if [ "$VAR0" = 'debian' ]; then
	echo 'DEBIAN based'
elif [ "$VAR0" = 'rhel' ]; then
	echo 'RHEL based'
else echo 'SUSE based'

fi
