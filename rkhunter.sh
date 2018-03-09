#!/bin/sh
# execute each night
email="youremail@domain.com"

echo "" >> /var/log/rkhunter.log
echo `date` >> /var/log/rkhunter.log
rkhunter --versioncheck >> /var/log/rkhunter.log

rkhunter --update >> /var/log/rkhunter.log
rkhunter --propupd >> /var/log/rkhunter.log
rkhunter --check --sk --report-warnings-only >> /var/log/rkhunter-check.log
ISDIFF=`grep -v -f /var/log/rkhunter-check-old.log /var/log/rkhunter-check.log`
ISDIFF1=`grep -v -f /var/log/rkhunter-check.log /var/log/rkhunter-check-old.log`
if [ ! "$ISDIFF" = "" ] || [ ! "$ISDIFF1" = "" ];then
    cp /var/log/rkhunter-check.log /var/log/rkhunter-check-old.log
    echo "Diff: $ISDIFF";
    echo "Diff: $ISDIFF1";
    echo "##### NODEJS PROCESSES" >> /var/log/rkhunter-check.log
    echo `ps aux | grep nodejs` >> /var/log/rkhunter-check.log
    echo "##### NGINX PROCESSES" >> /var/log/rkhunter-check.log
    echo `ps aux | grep nginx` >> /var/log/rkhunter-check.log
    echo "##### HAPROXY PROCESSES" >> /var/log/rkhunter-check.log
    echo `ps aux | grep haproxy` >> /var/log/rkhunter-check.log
    echo "#####" >> /var/log/rkhunter-check.log
    cat /var/log/rkhunter-check.log | mail -s "rkhunter output $HOSTNAME" $email
fi
