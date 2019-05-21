#!/bin/bash
# 判断用户密码设置的是否一致

#stty -echo
read -s -p "请输入密码:" passwd1
echo
read -s -p "请再次输入密码:" passwd2
echo
if [ -z $passwd1 -o -z $passwd2 ] ;then 
	echo 密码不能为空 >&2
	exit 1
fi

if [ "$passwd1" == "$passwd2"  ];then
	echo ok
else
	echo Error >&2
	exit 1
fi

#stty echo
