#!/bin/bash
#
#
# 04-09-2023
# start writing functions
#
# 1st, check system type, systemd or sysinitd
#
# 2nd, keep old, while updating how the commands are called. instead of backticks "`", use the now
# excepted "$(command)".
#
# 3rn, use the journalctl from the old script, mod_ssh.sh.systemd for another function
#
# 4th, will have to write these funtions first, orig and mod_..., and the call them from the test
# system type function
#
# 5th, leave the email part of the original script in place, since that won't, hopefully, have to be updated
#
# 6th, have fun :)
#
# 7th, set up what file/var is written to depending on the unit used in journalctl
#
PATH="/usr/local/bin:/usr/bin:/bin"

os_ver () {
    os="$(grep -w ID_LIKE /etc/os-release | cut -f2 -d= | tr -d '[=\"=]' | cut -f1 -d' ')" || \
        os="$(grep -w ID /etc/os-release | cut -f2 -d= | tr -d '[=\"=]' )"
#    os="$(cat /etc/os-release | grep -w ID_LIKE | cut -f2 -d= | tr -d '[=\"=]' | cut -f1 -d' ')" || \
#        os="$(cat /etc/os-release | grep -w ID | cut -f2 -d= | tr -d '[=\"=]' )"

    if [ "$os" = 'debian' ]; then
        bad_sshd=("$(grep Invalid /var/log/auth.log.1)")
    elif [ "$os" = 'rhel' ]; then
        bad_sshd=("$(grep Invalid /var/log/secure-* | cut -f1 -d, )")
    elif [ "$os" = 'suse' ] || [ "$os" = 'fedora' ]; then
        bad_sshd=("$(grep USER_ERR /var/log/audit/audit.log )")
    else
        exit
#        echo "$os"
    fi
}

while system=$(ps -p1 | grep -o "init\|upstart\|systemd"); do
    if [ "${system}" = systemd ]; then
        bad_sshd=("$(journalctl -u ssh.service --no-pager --since -168hours --until today | grep Invalid)") || \
            bad_sshd=("$(journalctl -u sshd.service --no-pager --since -168hours --until today | grep Invalid)")
    elif [ "${system}" = init ]; then
        os_ver
#        bad_sshd=("$(grep -i Illegal /var/log/auth.lg.0)") # || \
#            bad_sshd=("$(grep -i Illegal /var/log/messages)")
    else
        exit
    fi
done #

ip_sshd=("$(grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' "${bad_sshd[@]}" | tr -d '\n' | sort -u)")

(( x=0 ))
while (( x<"${#ip_sshd[@]}" )); do
    whois "${ip_sshd[x]}"
    abs_eml=("$(grep -i "abuse" | grep -o "[[:alnum:]]*\@[[:alnum:]]*\.[[:alpha:]]*" | tr -d '\n' | sort -u)")
    if [ ! "${abs_eml[x]}" ]; then
        break
    else
        mail -s ssh\ attack "${abs_eml}" <<EOF

        Thank you for taking the time and concern to address this email.

        This email was sent to you from a cron job to notify the Admin and you the ISP 
        of attempted break ins from someone coming from your ip address or block of ip
        addresses.

        My time is $(date -R)

        Thank you.
        admin@$(dnsdomainname)

        "$"## have to find how to write this-- ip_sshd[x] of bad_sshd[x] ???

EOF


    fi
done
