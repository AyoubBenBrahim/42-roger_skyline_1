#!/bin/sh

dat=$(date)
rm -rf /var/www/test.com &> /dev/null
rm test.com.tar &> /dev/null
ID=$(nc -l -p 60000)
sleep 5
echo "$dat:    ID=$ID" >> /var/www/archive.txt &> /dev/null
curl https://transfer.sh/$ID/test.com.tar -o test.com.tar &> /dev/null
sleep 5
tar -xmf ./test.com.tar -C ./var/www/ &> /dev/null

