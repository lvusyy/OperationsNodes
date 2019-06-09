#!/bin/bash
#自动修改ssh端口为8080
sed -i /Port/c"Port 8080" /etc/ssh/sshd_config
echo "iptables-restore < /etc/sysconfig/iptables" >>/etc/rc.local
iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
iptables-save > /etc/sysconfig/iptables
echo "iptables-save > /etc/sysconfig/iptables" >/etc/init.d/shutdownsh
chmod +x /etc/init.d/shutdownsh
ln -s /etc/init.d/shutdownsh /etc/rc6.d/K01shutdownsh
ln -s /etc/init.d/shutdownsh /etc/rc0.d/K01shutdownsh
ln -s /etc/init.d/shutdownsh /var/lock/subsys/
systemctl restart sshd
