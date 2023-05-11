#!/bin/bash 
#
### thanks for downloading this.  helpfully this will help alert some people to
### the fact they have been being used to crack other people's system.
#
### change from mod_ssh.sh.txt to mod_ssh.sh
### to watch this run --> bash -o xtrace mod_ssh.sh (as su or sudo)
#
### written for debian
### things needed: whois, mail program  (tested with postfix)
###                                     (please make sure you're not relaying)
### set it up as a cron job to run after your logs rotate.
### you might have to change where your auth.log is (or which one .0 or .1)
### centos -- /var/log/secure (or secure.date_rotated)
#
PATH="/usr/local/bin:/usr/bin:/bin:" 
 
HOSTNAME=`dnsdomainname` 
CURRENT=`date -R` 

mkdir SSH_Abuse ### we are going to do everything in a dir that we make 
cd SSH_Abuse    ### that way we can keep things nice and clean. 

VAR0=`cat /etc/os-release | grep -w ID_LIKE | cut -f2 -d= | tr -d [=\"=] |\
    cut -f1 -d' '`
VAR0="${VAR0:=`cat /etc/os-release | grep -w ID | cut -f2 -d= | tr -d [=\"=]`}"

if [ "$VAR0" = 'debian' ]; then
    grep Invalid /var/log/auth.log.1 > "bad_sshd"
elif [ "$VAR0" = 'rhel' ]; then
    grep Invalid `/var/log/secure-* | cut -f1 -d,` > "bad_sshd"
elif [ "$VAR0" = 'suse' || "$VAR0" = 'fedora' ]; then
    #find out how suse rotates logs
    grep USER_ERR /var/log/audit/audit.log > "bad_sshd"
else exit
echo "$VAR0"
fi

grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' "bad_sshd" | sort -u -o ip_sshd

while VAR1=`head -n1 ip_sshd`; do  
    if [ ! "$VAR1" ] ; then  
    	break  ## if $VAR1 is empty go to mail
    else VAR2=`whois "$VAR1" | grep -i abuse | \
	    grep -o [[:alnum:]]*\@[[:alnum:]]*\.[[:alpha:]]* | sort -u` 
    fi

VAR3=`grep "VAR1" bad_sshd`

#mail -s ssh\ attack "$VAR2" <<EOF
#
#Thank you for taking the time and concern to address this email.
#
#This email was sent to you from a cron job to notify the Admin and you the ISP 
#of attempted break ins from someone coming from your ip address or block of ip
#addresses.
#
#My time is "$CURRENT"
#
#Thank you.
#admin@$HOSTNAME
#
#"$VAR3"
#
#
#EOF
sed -i '1d' ip_sshd
continue
done 

cd ../ 
rm -rf SSH_Abuse  ### clean everything up 
exit 0  ### :) all done. 
# 
###  Copyright (C) 2005, 2009, 2016 chadbrabec@gmail.com
