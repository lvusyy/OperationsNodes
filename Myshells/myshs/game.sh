#!/bin/bash

isExit=1

isValidInput()
{
	if [ -z $1 ];then
	echo "没有输入任何字符" >&2
	exit 1
	elif [ $1 == "石头" -o $1 == "剪刀" -o $1 == "布"  ];then
		return 0
	elif [ $1 == "exit" ];then
		exit 0
	else
		echo  -e "你需要输入 \033[31m石头\033[0m \033[32m剪刀\033[0m \033[34m布\033[0m 或 \033[35mexit\033[0m 退出"
		exit 1
	fi
}

while [ $isExit -eq 1 ]
do
	read -p "请出拳,石头,剪刀,布 或 eixt 退出程序:"  op
	isValidInput $op
	
	case $[RANDOM%3] in
	0)
	if [ $op == "布" ];then
		echo "You Win"
	elif [ $op == "石头" ];then
		echo "draw tie"
	else
		echo "You Lost"
	fi;;
	1)

        if [ $op == "石头" ];then
                echo "You Win"
        elif [ $op == "剪刀" ];then
                echo "draw tie"
        else
                echo "You Lost"
        fi;;
	

	2)
	if [ $op == "剪刀" ];then
                echo "You Win"
        elif [ $op == "剪刀" ];then
                echo "draw tie"
        else
                echo "You Lost"
        fi;;

	*)
	exit 0
	esac
done
