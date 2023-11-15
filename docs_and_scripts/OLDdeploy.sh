#!/bin/bash

curl --max-time 0.1 -s 10.12.19.23:40000
curl --max-time 0.1 -s 10.12.19.23:50000
rm ayoub.com.tar &> /dev/null
chmod -R 777 ayoub.com
tar -cf ayoub.com.tar ayoub.com
chmod 777 ayoub.com.tar
res=$(curl --progress-bar --upload-file ./ayoub.com.tar https://transfer.sh/ayoub.com.tar)
ID=$(echo "$res" | awk -F'/' '{print $4}')
echo "$ID" | nc 10.12.19.23 60000
echo "$ID"

#curl --max-time 0.1 -s 10.12.19.23:40000
#curl --max-time 0.1 -s 10.12.19.23:50000
#rm test.com.tar &> /dev/null
#tar -cf test.com.tar test.com
#res=$(curl --progress-bar --upload-file ./test.com.tar https://transfer.sh/test.com.tar)
#ID=$(echo "$res" | awk -F'/' '{print $4}')
#echo "$ID" | nc 10.12.19.23 60000
#echo "$ID"
