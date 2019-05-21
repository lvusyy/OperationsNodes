#!/bin/bash
#检测是否管理员用户

function root()
{
	if [ $1 -eq 0 ];then
	echo "欢迎管理员用户:${USER}";exit 0
	else
	echo "欢迎普通用户:${USER}" ;exit 0
	fi
}

[ $UID -eq 0 ] && root $UID || root $UID
