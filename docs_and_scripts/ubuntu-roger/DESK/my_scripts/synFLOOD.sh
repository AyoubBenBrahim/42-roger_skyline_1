#!/bin/bash

pkill watch 
#watch -n 2 bash /DESK/my_scripts/anti_attacks/anti_PortScan.sh > /dev/null 2>&1 &
watch -n 2 bash /DESK/my_scripts/anti_attacks/anti_syn_flood.sh > /dev/null 2>&1 &
