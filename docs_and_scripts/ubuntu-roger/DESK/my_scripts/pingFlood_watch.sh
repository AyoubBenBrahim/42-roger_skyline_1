#!/bin/bash

pkill watch
watch -n 3 bash /DESK/my_scripts/anti_attacks/anti_pingFLOOD.sh > /dev/null 2>&1 &
