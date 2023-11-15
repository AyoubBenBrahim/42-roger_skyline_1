#!/bin/sh

#cat /var/log/syslog | grep "RELOAD (crontabs/root)" | tail -n 1 > cron_update.txt
date -r /var/spool/cron/crontabs > /DESK/my_scripts/cron_update.txt

dif=$(diff /DESK/my_scripts/cron_update.txt /DESK/my_scripts/cron_last_update.txt)
if [ "$dif" != "" ]; then
    #echo "Crontab file has been modified" | sudo /usr/sbin/sendmail root
    sudo sendmail root < /DESK/my_scripts/email.txt
    cat /DESK/my_scripts/cron_update.txt > /DESK/my_scripts/cron_last_update.txt
else
	echo "Crontab file not MODIFIED" | sudo /usr/sbin/sendmail root
fi

