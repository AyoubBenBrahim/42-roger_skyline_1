#!/bin/bash

while true
do
 bash /DESK/anti_DDOS.sh > /dev/null 2>&1 &
 bash /DESK/anti_PortScan.sh > /dev/null 2>&1 &
 bash /DESK/anti_pingFLOOD.sh > /dev/null 2>&1 &
 sleep 2.5
done
