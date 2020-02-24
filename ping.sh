#!/bin/bash
LOGFILE="/home/denis/result_of_ping"
IPS='10.19.0.6' # Здесь можешь перечислить список IP адресов каждый ip с новой строчки или через пробел!

function zerg_ping (){
for IP_ADDRESS in ${IPS}; do
   #echo \n 
   #echo "TEST FOR ${IP_ADDRESS}"
   ping -q -c2 ${IP_ADDRESS} > /dev/null
   if [ $? -eq 0 ] 
   then
   #echo date=$(date '+%Y-%m-%d %H:%M:%S') >> $LOGFILE 2>&1 # Пишем в лог файл "IP" если пингуется, дату и время.
   #echo ${IP_ADDRESS} "Pingable" >> $LOGFILE 2>&1
   else
   #echo date=$(date '+%Y-%m-%d %H:%M:%S') >> $LOGFILE 2>&1 # Пишем в лог файл "IP" если не пингуется, дату и время.
   #echo ${IP_ADDRESS} "Not Pingable" >> $LOGFILE 2>&1
   #echo "Killing all opened  openVPN services!"
   PID=`ps -eaf | grep openvpn | grep -v grep | awk '{print $2}'`
   if [[ "" !=  "$PID" ]]; then
   #echo "killing $PID"
   kill -9 $PID
   fi
   #sleep 5s  # Pause
   read -p 'Pausing for 30 seconds' -t 1
   #echo \n
   #echo "Runing OpenVPN!"
   openvpn --config /home/denis/.ovpn/Synology/VPNConfig.ovpn &
   fi

done
}

while true; do
   #sleep 5s 
   read -p 'Runing my function after pause' -t 1
   #echo"Run my function zerg_ping"
   zerg_ping
done
