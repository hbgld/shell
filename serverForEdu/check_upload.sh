#!/bin/bash
workdir=${1:-/var/ftp/upload}
i=0
red="\033[31m"
green="\033[32m"
sysColor="\033[0m"
un_upload=()
while read line;do
	pinyin=$(awk '{print $2}' <<< $line)
	name=$(awk '{print $1}' <<< $line)
	! ls $workdir|egrep -i "$pinyin|$name" &> /dev/null && un_upload[$i]=$name && let i++
done < /root/name-pin.txt

[ ${#un_upload} -eq 0 ] && echo -e "${green}优秀，全部交齐了！${sysColor}" && exit
echo -n "未交作业的同学："
echo -e "${red}${un_upload[*]}${sysColor}"
