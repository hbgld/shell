#!/bin/bash
win=10.20.154.250
Dirs=(Homework Books Isos Note Software Videos)
cd /var/ftp
mount |grep -q "ftp"  && exit
for dir in "${Dirs[@]}";do
	[ -d "$dir" ] || mkdir $dir
	mount -t cifs -o password="" //$win/ftp/$dir $dir
done
