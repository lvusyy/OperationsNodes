#!/bin/bash
#编写脚本,使用 read 提示用户输入一个字符,使用 case 语句判断用户输入的是

read -p "输入一个字符" str
if [ ${#str} -eq 1 ];then
case $str in
[a-z] | [A-Z])
	echo 你输入了字母;;
[0-9])
	echo 你输入了数字;;
*)
	echo 其他符号。
esac
else 
	echo 你需要输入一个字符才行.
	exit 1
fi
