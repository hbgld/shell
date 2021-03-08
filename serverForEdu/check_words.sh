#!/bin/bash
#set -x
file=/var/ftp/words.txt
number=${1:-10}
while read line;do
	echo "$RANDOM $(awk '{print $1}' <<< $line)"
done < $file |sort -n |awk 'NR<='$number'{print $2}'
