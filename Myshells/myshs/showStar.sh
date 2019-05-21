#!/bin/bash
#使用循环打印 5*5 的星星,脚本输出如下形状:(5 行,5 列),备注:echo -n 可以不换行输出。
if [ $# -eq 2 ];then
for i in `seq 1 $1`;do
	for i in `seq 1 $2`;do
		echo -n "* "
	done
	echo
done
else
echo showStar  行 列 
fi
