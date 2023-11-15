#!/bin/bash

pkill watch
watch -n 2 bash /DESK/my_scripts/anti_attacks/anti_DDOS.sh > /dev/null 2>&1 &
