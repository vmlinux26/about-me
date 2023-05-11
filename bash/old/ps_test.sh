#!/bin/bash

while VAR1=`ps ax | head | grep init`; do
    if [ "$VAR1" ]; then
	echo "$VAR1"; break
    else
	exit
    fi
#continue
done
