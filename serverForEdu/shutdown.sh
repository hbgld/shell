#!/bin/bash
red="\033[31m"
none="\033[0m"
echo -e "${red}Warning! this is real-server.${none}" 
echo -ne "Type '${red}yes${none}' to continue: " 
read sht
[[ ! "$sht" =~ ^[yY][eE][sS]$ ]] && exit
/usr/sbin/shutdown "$@"
