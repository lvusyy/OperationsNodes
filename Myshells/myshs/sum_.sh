#!/bin/bash
#对３个输入的数字进行求和

function isNumber()
{
	expr $1 "+" 10 &>/dev/null
	if [ $? -eq 0 ]; then
		echo 0
	else
		echo 1
	fi

}


read -p "请输入第一个数字:" numA
read -p "请输入第一个数字:" numB
read -p "请输入第一个数字:" numC
if [ -z "$numA" -o -z "$numB" -o -z "$numC" ] ;then 
echo "请按需求输入3个数字" >&2
exit 3
elif  [ `isNumber $numA` -eq 0  -a `isNumber $numB` -eq 0 -a `isNumber $numC` -eq 0  ] ;then
	echo "$numA+$numB+$numC=`expr $numA "+" $numB "+" $numC`"
	exit 0
else
	echo "你输入的有包含非数字字符,请检查!" >&2
	exit 1

fi

