#!/bin/bash
#logfile=/var/log/dianming.log
#today=$(date +%F)
hidden="\033[?25l"                         # 隐藏光标
unhidden="\033[?25h"                       # 取消隐藏光标
#[ -f $logfile ] || touch $logfile
names=($(sed '/#/d' /var/ftp/name.txt))
num=${#names[*]}
second=1
echo -ne "$hidden"
for i in {1..150};do
	index=$[RANDOM%num]
	lucker=${names[index]}
	printf "\r%-10s" $lucker
	if [ $i -le 9 ];then
		second=$(echo "$second-0.1"|bc)
	elif [ $i -le 140 ];then
		second=0.01
	else
		second=$(echo "$second+0.1"|bc)
	fi
	sleep $second
done
echo -e "$unhidden"
#echo "$today        $lucker" >> $logfile
