#!/bin/bash
# https://stackoverflow.com/questions/17291233/how-to-check-internet-access-using-bash-script-in-linux
IP_OPENVPN='10.19.0.1'

function kill_openvpn() {
PID=`ps -eaf | grep openvpn | grep -v grep | awk '{print $2}'`
if [[ i"" !=  "$PID" ]]; 
then
  echo "Остановили 'PID' процесс №: $PID"
  kill -9 $PID
else
  echo "Сервиса OpenVpn нет!"
fi
}

function_run_openvpn() {
echo "Запускаю OpenVPN!"
openvpn --config /home/denis/.ovpn/Synology/VPNConfig.ovpn & 
}

function ping_openvpn {
    echo "Trying to ping ${IP_OPENVPN}"
    ping -q -c2 ${IP_OPENVPN} > /dev/null
    if [ $? -eq 0 ]
    then
        echo ${IP_OPENVPN} "OpenVPN, на связи, cool!"
    else
        echo ${IP_OPENVPN} "OpenVPN не пингуется!"
        kill_openvpn
        read -t 1 -p "Пауза в 1 секунду перед запуском OpenVPN!" 
        function_run_openvpn
    fi
}

TIMESTAMP=`date +%s`
while [ 1 ]
  do
    nc -z -w 5 8.8.8.8 53  >/dev/null 2>&1
online=$?
    TIME=`date +%s`
    if [ $online -eq 0 ]; then
      #echo "`date +%Y-%m-%d_%H:%M:%S_%Z` 1 $(($TIME-$TIMESTAMP))" | tee -a log.csv
      echo "`date +%Y-%m-%d_%H:%M:%S_%Z`"
      echo "Инет соединение есть!"
      ping_openvpn
    else
      #echo "`date +%Y-%m-%d_%H:%M:%S_%Z` 0 $(($TIME-$TIMESTAMP))" | tee -a log.csv
      echo "`date +%Y-%m-%d_%H:%M:%S_%Z`"
      echo "Нет интернет соединения!"
      kill_openvpn
    fi
    TIMESTAMP=$TIME
    sleep 15
  done;
