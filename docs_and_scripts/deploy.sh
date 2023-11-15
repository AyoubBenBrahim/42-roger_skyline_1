#!/bin/bash

curl --max-time 0.1 -s 10.12.19.23:40000
curl --max-time 0.1 -s 10.12.19.23:50000
#curl --max-time 0.1 -s 10.12.0.253:40000
#curl --max-time 0.1 -s 10.12.0.253:50000
rm ayoub.com.tar &> /dev/null
chmod -R 777 ayoub.com
tar -cf ayoub.com.tar ayoub.com
chmod 777 ayoub.com.tar
pv ayoub.com.tar | nc 10.12.19.23 60000
