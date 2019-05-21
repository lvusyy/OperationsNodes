#!/bin/bash
#while 死循环重复执行 clone-vm7 命令,实现连续创建多个虚拟机
#virsh list --all|awk '/rh7/{print $2}'|xargs -n 1  virsh undefine 

while :
do
        let count++
        if [ "$count" == "2" ] ;then
                #exit 0
                break
        else
                echo $count | clone-vm7
        fi
done
echo "共创建${count}个虚拟机"

