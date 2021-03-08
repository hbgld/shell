#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
rip=10.3.148.250
mnt=/cifs/
dir_dst=/var/ftp/
ping -c1 $rip &> /dev/null || exit
df |grep cifs &> /dev/null || mount.cifs //$rip/FTP $mnt  -o password=''
rsync -az  --exclude="*.iso" $mnt  $dir_dst
dos2unix  /var/ftp/words.txt  &> /dev/null
