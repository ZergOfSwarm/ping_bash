#!/bin/bash
#  https://www.2daygeek.com/linux-bash-script-auto-restart-services-when-down/

serv=network-manager
sstat=dead
systemctl status $serv | grep -i 'running\|dead' | awk '{print $3}' | sed 's/[()]//g' | while read output;
do
echo $output
if [ "$output" == "$sstat" ]; then
    systemctl start $serv
    echo "$serv service is UP now.!" | mail -s "$serv service is DOWN and restarted now On $(hostname)" d358468115905@gmail.com
    else
    echo "Status of $serv service is running"
    fi
done
