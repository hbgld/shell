#!/bin/bash
# 脚本将所有名单成员进行分组，共6排，每两排的1234列为一组，5678列为一组，执行时接组别，随机点一名该组成员

# 名单内容类似如下(不含最前面的#)：
# 1 2 3 4  5 6 7 8
# q w e r  t y u i
# ...
# ###讲 台###

file=name-2302.txt
for i in {1..6};do
	if [ $[$i%2] -eq 1 ];then
		r1=$i;r2=$((i+1))
		f1=1;f2=4
	else
		r1=$((i-1));r2=$i
		f1=5;f2=8
	fi
	# 定义数组，数组名称中包含变量
	declare -a "g$i=($(tac $file|sed '1d'|sed -n "$r1,$r2 p"|awk -v f1=$f1 -v f2=$f2 '{for(i=f1;i<=f2;i++){print $i}}'))"
done

# 调用数组名称中含变量的数组
eval group="g$1[@]"
a=("${!group}")
#echo ${a[@]}
len=${#a[*]}
index=$[RANDOM%len]
echo ${a[$index]}
