##### LVS

1. 前端: 负载均衡层
由一台或多台负载调度器构成

2. 中间:服务器群组层
由一组实际运行应用服务的服务器组成

3.　后端：　数据库存储层
提供共享存储空间的存储区域



 lvs 术语
 
 #### directorServer 调度服务区
 将负载分发到Real Server 的服务器
 #### Real server 真是服务器
 真正提供应用服务的服务器
 #### VIP 虚拟ip地址
 公布给用户访问的虚拟IP地址
 #### RIP 真实IP地址
 集群节点上使用的IP地址
 DIP 调度器链接节点服务器的IP地址
 
> NAT,DR,TUN

rr,	wrr,	lc,		wlc
轮循    权重	最少连接	带权重最少连接

-i   -g -m
TUN  DR  NAT  

yum install ipvsadm
 
ipvsadm -A 创建虚拟服务器
ipvsadm -a 添加real server

 nginx:用户访问4.5 nginx去访问web(2.5--2.100)
  web把页面返回是nginx,nginx返回给用户.
  
  
  lvs:[路由器,数据包转发]NAT
   
添加集群
ipvsadm -A -t 192.168.4.15:80 -s rr
ipvsadm -a -t 192.168.4.15:80 -r 192.168.2.100 -m        [-w 1]
ipvsadm -a -t 192.168.4.15:80 -r 192.168.2.200:80 -m

开启路由转发
vim /etc/sysctl.conf
net.ipv4.ip_forward=1
sysctl -p


lvs-DR 集群

* arp_ignore (定义回复ARP广播的方式)
- 0(默认值)
回应所有的本地地址ARP广播,本地地址可以配置在任意网络接口
- 1
只回应[配置在入站网卡接口上的任意IP地址的arp广播

* arp_anounce
- 0(默认)
	使用配置在任意网卡接口上的本地IP地址
-2 
	对查询目标使用最适当的本地地址. 在此模式下将忽略这个IP数据吧的源地址并尝试选择与能与改地址通讯的本地地址.首要是选择所有的网络接口的子网中外出访问子网中包含该目标IP地址的本地地址.如果没有合适的地址被发现,将选择当前的发送网络接口其他的有可能接受到该ARP回应的网络接口进行发送.

ehco 1 >/proc/sys/net/ipv4/conf/lo/arp_ignore
ehco 2 >/proc/sys/net/ipv4/conf/lo/arp_arp_announce
ehco 1 >/proc/sys/net/ipv4/conf/all/arp_ignore
ehco 2 >/proc/sys/net/ipv4/conf/all/arp_announces

可以永久修改 /etc/sysctl.conf
net.ipv4.conf.lo.arp_ignore=1
net.ipv4.conf.lo.arp_arp_announce=2
.
.
> arp防火墙.
	arp防火墙也可以禁止对VIP的arp请求
	yum install -y arptables_if
	arptables -A IN -d <vip> -j DROP
	arptables -A OUT -s <vip> -j mangle --mangle-ip-s <rip>


