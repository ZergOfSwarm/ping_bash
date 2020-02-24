#!/bin/bash

LOGFILE="/home/denis/result_of_ping"
IPS='192.168.18.12
192.168.18.18
192.168.18.1
8.8.8.8'

for IP_ADDRESS in ${IPS}; do
   echo "TEST FOR ${IP_ADDRESS}"
   ping -q -c2 ${IP_ADDRESS} > /dev/null
   if [ $? -eq 0 ]
   then
   echo ${IP_ADDRESS} "Pingable"
   else
   echo date=$(date '+%Y-%m-%d %H:%M:%S') >> $LOGFILE 2>&1
   echo ${IP_ADDRESS} "Not Pingable" >> $LOGFILE 2>&1 
   fi
done
