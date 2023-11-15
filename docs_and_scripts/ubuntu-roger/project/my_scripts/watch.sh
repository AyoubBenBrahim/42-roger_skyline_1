#!/bin/bash

#watch -n 2 bash /DESK/my_scripts/DDOS_watch.sh > /dev/null 2>&1 &
#watch -n 2 bash /DESK/my_scripts/synFlood_watch.sh > /dev/null 2>&1 &

pkill watch
watch -n 2 bash /DESK/my_scripts/anti_attacks/anti_pingFLOOD.sh > /dev/null 2>&1 &
watch -n 2 bash /DESK/my_scripts/anti_attacks/anti_syn_flood.sh > /dev/null 2>&1 &
