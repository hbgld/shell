#!/bin/bash
weekday=$(date +%w)
[[ $weekday -eq 0 || $weekday -ge 6 ]] && exit
basedir="/var/ftp/upload"
dir=$(date --date=yesterday +%m%d)
cd $basedir
if ls -l |grep "^-" |grep -q ".txt$" ;then
	[ -d "$dir" ] || mkdir $dir
	ls -l |awk '/^-/{print $NF}' |xargs -i mv {} $dir
fi
