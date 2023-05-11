#!/bin/bash 
# 
# 04-09-2023 looking at fixing some of the old bash(3 - 4) to work with bash 5, lookin at using
# systemd since it seems the most used as now, yet will also attempt to have it work with sysinit,
# and i have been working again with bash programming/scripts and have learned more.
# i have left all of the comments here, and will make this original into a README so that the final
# script isn't so long.
#
# 04-26-2020 (from last write) looked at using systemd, with the journalctl to capture the attempted
# logins with ssh
#
# 05-29-2016
# changed the lookup of the ip addresses in the made file and the whois lookup.
#
# may 4, 2009 
# changed the way that the log files are searched. 
# 
# july 23, 2005 
# 
# i've noticed a couple of discrepancies in how some isp's have their whois info set up.  i'm 
# working on getting this fixed, so that all ips will get sent to the proper people. this is somewhat fixed with the 
# additional 'whois' statements.  it's an ugly hack but i'm working on it. 
# 
# looking at making a file that keeps the main blocks of ips in it with the abuse info so this becomes faster. 
# 
# april 03, 2005 
# 
# I wrote this because I was getting tired of all the attempts from the script kiddies out there. Hopefully if 
# enough people can use this program, and do use it, we can get the ISPs to take a look at, and maybe catch 
# some of the little shites that are running the scripts. 
# 
# A couple of things that you're going to need to make this program work properly is to have your dnsdomainname 
# set, a MTA (I'm using postfix) that is working, and hopefully not relaying others mail :­), and your machine clock syncing to an 
# ntp server.  The last one isn't neccesary, but I believe it's important. 
# 
# I made a system user admin, and have it ran as a cron job from the admin user when my files rotate.  This way it's 
# not going to flood the ISPs mail, and yours, with continued sends of the same thing.  Also this script was 
# written for my server(debian), so you might have to modify it to fit yours.  The modification should only be which 
# log file it's searching. If people email me with where the 'Illegal' attempts are located on what distro I will 
# modify the script. 
# 
# You can see what this is doing by running ""bash ­-o -xtrace "mod_ssh.sh" (without the quotes) from the dir that you put it in. 
# 
# If you are going to run this from a cron job as I have, make sure that you specify, "SHELL=/bin/bash" after the 
# name of the file so it runs properly. 
#
PATH="/usr/local/bin:/usr/bin:/bin:" 
# 
HOSTNAME=`dnsdomainname` ### just a couple of vars that i've set up right away. 
TIMEZONE=`cat /etc/timezone` 
CURRENT=`date` 
UTC=`date -u` 
#
mkdir abuse ### we are going to do everything in a dir that we make 
cd abuse ### that way we can keep things nice and clean. 
# 
grep -i Illegal /var/log/auth.log.0 > "bad_sshd" ### finding the offenders. 
grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' "bad_sshd" | sort -u -o ip_sshd
#
### this grabs the first ip in the list. checking to make sure the loop will stop when there are no more ips in the list.
while VAR1=`head -n1 ip_sshd`; do  
    if [ ! "$VAR1" ] ; then  
	break  
	else VAR2=`grep -w "$VAR1" /var/log/auth.log.0` ### builds the list to send to the isp. 
    fi

    until [ "$VAR3" ] ; do 
	if VAR3=`whois "$VAR1" | grep -io abuse[[:alnum:]]*\@[[:alnum:]]*\.[[:alpha:]]* | sort -­u` ; then ### fixed to one return line only 
	    break 
	fi
    done 
#
mail­-s ssh\ attack "$VAR3" <<EOF 
 
Thank you for taking the time and concern to address this email. 
 
This email was sent to you from a cron job to notify the admin and you, the isp, 
of attempted break ins from an ssh script coming from someone in your block of ip addresses. 
 
My timezone is ${TIMEZONE}. 
My current time is ${CURRENT}. 
Current UTC time is ${UTC}. 
 
Thank you. 
admin@$HOSTNAME 
 
${VAR2} 
 
EOF 
# 
sed -i '1d' ip_sshd ### gets rid of the first ip that we searched so the loop continues
done 
#  
rm -f ip_sshd bad_sshd ### cleans everything up that we made. 
cd ../ 
rm -rf abuse 
exit 0 ### :­) all done. 
# 
# 
# 
# Copyright (C) 2005, 2009, 2016  Chad Brabec <chad\@cerberus.cc>,<chadbrabec\@gmail.com> 
# 
# 
# 
# This program is free software; you can redistribute it and/or modify 
# it under the terms of the GNU General Public License as published by 
# the Free Software Foundation; either version 2 of the License, or (at 
# your option) any later version. 
# 
# This program is distributed in the hope that it will be useful, but 
# WITHOUT ANY WARRANTY; without even the implied warranty of 
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
# General Public License, http://www.gnu.org/copyleft/gpl.html, for more details. 
# 
# If you find this script useful and would like to modify it to make it better 
# please email me with the changes. 
