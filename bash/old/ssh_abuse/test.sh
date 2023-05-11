#!/bin/bash

VAR0=`ls /etc/ | grep debian`

if [ "$VAR0" ]; then
    echo "DEBIAN"
    else echo "NOT debian"
fi
