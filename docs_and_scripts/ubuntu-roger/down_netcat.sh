#!/bin/sh

 cd /tmp
 #rm ayoub.tar &> /dev/null
 nc -l -p 60000 > ayoub.tar
 rm -rf /var/www/ayoub.com/* &> /dev/null
 tar -xmf ayoub.tar --owner root --group root --no-same-owner -C /var/www/ayoub.com &> /dev/null

