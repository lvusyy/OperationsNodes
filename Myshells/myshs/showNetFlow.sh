#!/bin/bash
#显示网卡流量

tx=''
rx=''
clear
while :
do
echo -n -e "`ifconfig eth0 |grep 'TX p'`   `ifconfig eth0 |grep 'RX p'`\r  "
sleep .5
done
