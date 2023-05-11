#!/bin/bash

cp /home/chadb/share/ip_sshd /home/chadb/share/bash/mod_ssh/./

while VAR1=`head -n1 ip_sshd`; do  
    if [ ! "$VAR1" ] ; then  
	break  ## if $VAR1 is empty go to mail
    else VAR2=`whois "$VAR1" | grep -i abuse | \
       	grep -o	[[:alnum:]]*\@[[:alnum:]]*\.[[:alpha:]]* | sort -u` 
    fi

echo "$VAR2"
sed -i '1d' ip_sshd
continue
done
