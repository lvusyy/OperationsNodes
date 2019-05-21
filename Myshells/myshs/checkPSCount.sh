#!/bin/bash
#检测系统进程数量,如果超过100发送邮件给root

MaxPSCount=100

function sendMail()
{
	echo $1 |mail -s "_MAX_PROCESS_ALTER" root
}

function getPSCount()
{
	#return 最大只能返回数值0-255
	echo `ps -e |wc -l `

}

psCount=$(getPSCount )
#echo $psCount
if [ $psCount -gt $MaxPSCount  ];then
	sendMail "当前进程超过设置的最大进程数.当前共:$psCount个进程"
else
	echo "当前系统进程符合正常标准"
fi
