#!/bin/bash 
#脚本判断系统中是否有该账户
read -p "请输入需要检测的用户名:" user
[ -z $user ] && exit 1
`id $user &>/dev/null` && echo -e  "\033[32m用户:${user} 存在此系统中\033[30m" || echo -e "\033[31m用户:${user} 不存在此系统中\033[30m" 
