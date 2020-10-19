#!/bin/bash

flag=0
TIMESTAMP=`date +%s`
sleep 180 # Пауза для прогрузки всех сервисов полсе включения OrangePi.

while [ 1 ]
  do
    echo -n >/dev/tcp/8.8.8.8/53 2>&1
    online=$?
    TIME=`date +%s`
    if [ $online -eq 0 ] && [ $flag -eq 0 ]; then
        #echo "WiFi есть!"
        echo "'Попытка подключения в' `date +%H:%M:%S_%d-%m-%Y_%Z` 1 $(($TIME-$TIMESTAMP))" | tee -a $HOME/scripts/log_of_connection.txt # Укажи правильный путь куда сохранять файл!
        flag=2
        #echo "Устанавливаю Flag = " $flag
    elif [ $online -eq 0 ] && [ $flag -eq 2 ];
    then 
        #echo "Flag = "$flag
        echo "" > /dev/null
    else
        #echo "WiFi отключен!"
        flag=0
        #echo "Попытка установить соединение!"
        #echo "`date +%d-%m-%Y_%H:%M:%S_%Z`"
        # Перезапуск NetworkManager
        nmcli networking off
        sleep 1 # Пауза для отарботки команды.
        nmcli networking on 
        sleep 1 # Пауза для отарботки команды.
    fi
    TIMESTAMP=$TIME
    sleep 1
  done;
