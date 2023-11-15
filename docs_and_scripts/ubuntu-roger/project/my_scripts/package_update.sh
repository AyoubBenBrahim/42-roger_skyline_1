#!/bin/sh

 dat=$(date)
 path=/var/log/update_script.log
 
 printf "\n===================UPDATE && UPGADE========================\n" >> $path
 printf "$dat\n" >> $path
 #screen -S update -dm apt-get -y update >> $path
 bash -c 'apt-get -y update >> /var/log/update_script.log &'
 bash -c 'apt-get -y upgrade >> /var/log/update_script.log &'
 printf "\n===========================================\n\n" >> $path
 
# echo "update"
#apt-get update >> /var/log/update_script.log 2>&1
#echo "upgrade"
#apt-get upgrade >> /var/log/update_script.log 2>&1
