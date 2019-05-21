#!/bin/bash
#新建或者删除指定用户
#
#
if [ "$1" = "-c" -a $# -eq 3 ];then
	useradd $2 && echo $3 |passwd $2 --stdin  && echo "`date` 用户:{$2}创建成功!" 2>>./useradd.log >/dev/null ;exit 0
	echo "$(date) 用户:${2}创建出错.more info read useradd.log"; exit 3
elif [  "$1" = "-r" -a $# -eq 2  ];then
	userdel $2 && echo 用户:${2}删除成功! 2>>./userdel.log;exit 0
	echo 用户删除出错.more info read userdel.log; exit 3
else
	echo '-c username password      创建用户' >&2
	echo '-r username               删除用户' >&2
	exit 1
fi
