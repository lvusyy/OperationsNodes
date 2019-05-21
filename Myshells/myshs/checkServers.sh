#!/bin/bash
# 判断系统中是否启动了 sshd、httpd、crond、vsftpd 服务

#ps -e |grep sshd &> /dev/null && echo sshd 已经启动 || echo sshd 没有启动
#ps -e |grep httpd &> /dev/null && echo httpd 已经启动 || echo httpd 没有启动
#ps -e |grep crond &> /dev/null && echo crond 已经启动 || echo crond 没有启动
#ps -e |grep vsftpd &> /dev/null && echo vsftpd 已经启动 || echo vsftpd 没有启动


for server in ssh httpd crond vsftpd;do
	ps -e |grep $server &> /dev/null && echo -e "\033[32m$server 已经启动 \033[0m" || echo -e "\033[31m$server 没有启动\033[0m"
done
