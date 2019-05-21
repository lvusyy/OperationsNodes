#!/bin/bash



wlanInit()
{

wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf
killall dhclient
dhclient wlan0

}

wlanInit
sleep 2
wlanRoute=`ip address show wlan0 |grep inet|grep -v inet6|awk '{print $4}'`
wlanRoute=${wlanRoute%.*}".1"
uproute(){
for ip in `cat ./routes`;do
    #isIp=`expr index $ip '#'`
    isIp=`echo "$ip" |grep -s '\#'`
    #echo $isIp
    if [ $isIp > 0 ];then
          echo "跳过$ip"
          continue
    fi
    echo "添加${ip}到路由表中使用的网关是 $wlanRoute"
    route add -host $ip gw $wlanRoute
done
}

if [ "$1" == "uproute" ];then
    uproute
    exit 0
fi

sleep 2
if [ -z $wlanRoute ];then
    echo "没有获取到wlan口IP"
    exit 1
fi
route del -net 0.0.0.0 gw 176.19.8.1 
route del -net 0.0.0.0 gw $wlanRoute
route add -net 0.0.0.0 gw $wlanRoute
route add -net 0.0.0.0 gw 176.19.8.1 

uproute(){
for ip in `cat ./routes`;do
    #isIp=`expr index $ip '#'`
    isIp=`echo "$ip" |grep -s '\#'`
    #echo $isIp
    if [ $isIp > 0 ];then
          echo "跳过$ip"
          continue
    fi
    echo "添加${ip}到路由表中使用的网关是 $wlanRoute"
    route add -host $ip gw $wlanRoute
done
}

uproute
