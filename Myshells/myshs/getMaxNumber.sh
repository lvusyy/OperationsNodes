#!/bin/bash

#getmax

op_len=3

if [ ! -z $1 ];then
	op_len=$1
fi

arr_number[0]=0

isNumber()
{
        expr $1 "+" 10 &>/dev/null
        if [ $? -eq 0 ]; then
                echo 0
        else
                echo 1
        fi

}




for i in `seq 0 $[op_len-1]`;do
read -p "请输入一个数字:" arr_number[i]

if [ -z  ${arr_number[i]} ];then
	echo 不能输入空字符 >&2
	exit 1
else
isN=`isNumber ${arr_number[i]}`
if [  $isN  -ne 0 ];then
echo "你输入的不是数字" >&2
	exit 2
fi
fi
done
len=${#arr_number[*]}
let len-=2


sort()
{
	for i in `seq 0 $1` ;do
        if [ ${arr_number[i]} -lt ${arr_number[i+1]}  ];then
        temp=${arr_number[i]}
        arr_number[i]=${arr_number[i+1]}
        arr_number[i+1]=$temp
        fi
	done

}

for ((a=$len;a>=0;a--));do
sort $a
done 

for i in ${arr_number[@]};do
	echo $i
done
