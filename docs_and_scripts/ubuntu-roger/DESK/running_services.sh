#!/bin/sh

#service --status-all | grep + 
systemctl list-units --all --type=service | grep "running" > services.txt
