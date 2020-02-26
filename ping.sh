#!/bin/bash
#LOGFILE="/home/denis/result_of_ping" # Раскомментировать если нужно вести log.file
IPS='192.168.3.1' # "IP" адресов который пингуем.
mqtt_server='192.168.3.12' # Здесь пропишем "IP" адрес "MQTT" сервера.

function zerg_ping (){ # Функция "zerg_ping" которая пингует и результат пишет либо в лог.файл или отправляет на MQTT.
for IP_ADDRESS in ${IPS}; do
   echo \n 
   echo "TEST FOR ${IP_ADDRESS}"
   ping -q -c2 ${IP_ADDRESS} > /dev/null # Заскомментировать эту строку если нужно вести log.file
   #ping -q -c2 ${IP_ADDRESS} && mosquitto_pub -h localhost -t "device/"$network$number -m "1" (Раскомментировать если нужно вести log.file)
   if [ $? -eq 0 ] 
   then
   #echo date=$(date '+%Y-%m-%d %H:%M:%S') >> $LOGFILE 2>&1 # Пишем в лог файл дату и время если не пингуется. (Раскомментировать если нужно вести log.file)
   #echo ${IP_ADDRESS} "Pingable" >> $LOGFILE 2>&1 # Пишем в лог файл "IP" и слово "Pingable". (Раскомментировать если нужно вести log.file)
   echo ${IP_ADDRESS} "Pingable" && mosquitto_pub -h $mqtt_server -t "IP-"$IPS -m "1" # Если пингуется пишем "1" в mqtt.
   else
   #echo date=$(date '+%Y-%m-%d %H:%M:%S') >> $LOGFILE 2>&1 # Пишем в лог файл дату и время если не пингуется. (Раскомментировать если нужно вести log.file)
   #echo ${IP_ADDRESS} "Not Pingable" >> $LOGFILE 2>&1 # Пишем в лог файл "IP" и слово "Not Pingable" (Раскомментировать если нужно вести log.file)
   echo ${IP_ADDRESS} "Not Pingable" && mosquitto_pub -h $mqtt_server -t "IP-"$IPS -m "0" # Если не пингуется пишем "0" в mqtt.
   # Перед запуском "OpenVPN" убиваем все запущенные сервесы с "OpenVPN".
   PID=`ps -eaf | grep openvpn | grep -v grep | awk '{print $2}'`
   if [[ "" !=  "$PID" ]]; then
   echo "killing $PID"
   kill -9 $PID
   fi
   # Не уверен, что здесь пауза нужна ну, поставил на всякий случай!
   #sleep 5s
   read -p 'Pausing for 5 seconds' -t 5
   echo \n
   echo "Runing OpenVPN."
   openvpn --config /home/user/.ovpn/VPNConfig.ovpn &
   fi

done
}

while true; do # Бесконечный цикл
   #sleep 5s 
   read -p 'Runing "zerg_ping" function after pause in 5 seconds' -t 5
   echo \n
   echo "Run my function zerg_ping"
   zerg_ping
done
