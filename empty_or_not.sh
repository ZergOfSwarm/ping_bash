#!/bin/bash
#Проверка переменная пустая или нет
_JAIL=5 # https://serverfault.com/questions/7503/how-to-determine-if-a-bash-variable-is-empty
if [[  ! "$_JAIL" ]] 
then 
    #echo "Empty: Yes"
    echo "" > /dev/null
else 
    echo "Not empty and = " $_JAIL
fi
