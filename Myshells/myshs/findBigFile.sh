#!/bin/bash
#找出系统中大于 1G 的文

files=$(find / -type f -size +1G 2>/dev/null)
fileCount=`echo $files |awk -F ' ' '{print NF}'`
if [ $fileCount -gt 10 ];then
echo -e "\033[31m共:${fileCount}个文件\033[30m"
else
echo -e "\033[32m共:${fileCount}个文件\033[30m"

	for i in $files;do
		echo -e "\033[33m$i\033[30m"
	done
fi
