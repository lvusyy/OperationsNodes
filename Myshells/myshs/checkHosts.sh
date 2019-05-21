#!/bin/bash
success=0 #成功记次
filed=0   #失败记次

setAlive()
{
	let success++
	echo -e "\033[32m176.19.8.$host 主机存活\033[30m"

}

function setFaild()
{
	let filed++
	
}

for host in `seq 1 111`;do
#trap "exit 1" 2 
trap "echo SIGINT" SIGINT
trap "echo SIGQUIT" SIGQUIT
trap "echo SIGTERM" SIGTERM
trap "echo SIGSTOP" SIGSTOP
ping -c 1 -i 0.2 -W 1 176.19.8.$host  &> /dev/null && setAlive || setFaild
done
echo "共:${success}个主机存活,${filed}个主机失败"
