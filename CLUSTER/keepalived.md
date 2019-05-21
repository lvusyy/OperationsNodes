keepalived

yum install keepalived


### web/后端 热备

### 调度算法

    1）RR   轮询

        Round Robin ：新的连接请求被轮流分配至各RealServer,优点是该算法无需记录当前所有连接的状态，效率高；但缺点是在RealServer当中如果有性能不均等的情况下，性能差的主机将负载比较大。该算法容易倒致服务器之间负载不均衡；

    2）WRR  加权轮询

        Weighted RR ：优点与RR一样，无需记录所有连接状态；通过设定一定的权重值来分配连接请求；
    3）SH   源地址哈希

        Source Hashing ：通过一个散列函数将去往同一个目的IP的请求映射到一台服务器或链路上。   

    4）DH   目标地址哈希

        Destination Hashing : 通过一个散列函数将来自同一个源IP的请求映射到一台服务器或链路上

    5）LC   最少连接数

        Least Connection ：根据当前各服务器的连接数来估计服务器的负载情况，把新的连接分配给连接数最小的服务器；负载率=active*256+inactive，值小的优先分配请求；
    6）WLC   加权最少连接数

        Weighted LC ：与LC类似，根据当前各服务器的连接数来估计服务器的负载情况，把新的连接分配给连接数最小的服务器；负载率=(active*256+inactive)/weight，值小的优先分配请求；   

    7）SED  最短期望延迟

        Shortest Expect Delay : 这个算法主要是优化LC的，在服务均在请求少的时候避免负载到一台服务器上做的优化；负载率=(active+1)*256/weight，值小的优先分配请求；
    8）NQ   永不排队

        Nerver Queue ：在负载低时，请求直接分配到空闲服务器上，不会产生请求等待；当服务器都很忙时，将轮询；

    9）LBLC  基于本地最少连接

        Locality-Based Least Connection：根据请求的目标IP地址找出该目标IP地址最近使用的RealServer，若该Real Server是可用的且没有超载，将请求发送到该服务器；若服务器不存在，或者该服务器超载且有服务器处于一半的工作负载，则用“最少链接”的原则选出一个可用的服务器，将请求发送到该服务器。

    10）LBLCR  带复制的基于本地最少连接

        Replicated and Locality-BasedLeast Connection ：该算法根据请求的目标IP地址找出该目标IP地址对应的服务器组，按“最小连接”原则从服务器组中选出一台服务器，若服务器没有超载，将请求发送到该服务器；若服务器超载，则按“最小连接”原则从这个集群中选出一台服务器，将该服务器加入到服务器组中，将请求发送到该服务器。




#### 配置

> 配置本地地址 arp

[root@web1 ~]# cd /etc/sysconfig/network-scripts/
[root@web1 ~]# cp ifcfg-lo{,:0}
[root@web1 ~]# vim ifcfg-lo:0
DEVICE=lo:0
IPADDR=192.168.4.15
NETMASK=255.255.255.255
NETWORK=192.168.4.15
BROADCAST=192.168.4.15
ONBOOT=yes
NAME=lo:0

> 处理 ARP相关信息
[root@web1 ~]# vim /etc/sysctl.conf
#手动写入如下4行内容
net.ipv4.conf.all.arp_ignore = 1
net.ipv4.conf.lo.arp_ignore = 1
net.ipv4.conf.lo.arp_announce = 2
net.ipv4.conf.all.arp_announce = 2
#当有arp广播问谁是192.168.4.15时，本机忽略该ARP广播，不做任何回应
#本机不要向外宣告自己的lo回环地址是192.168.4.15


keepalived 配置

vrrp_instance VI_1 {
 20     state MASTER //影响刚启动时候 的role
 21     interface eth0 //操作接口
 22     virtual_router_id 51 //区分keepalived不同项目
 23     priority 100 //猜拳的 大小
 24     advert_int 1 //间隔秒数 重新猜拳
 25     authentication {  //沟通验证
 26         auth_type PASS //验证类型
 27         auth_pass 1111  //验证密码
 28     }
 29     virtual_ipaddress {
 30         192.168.4.80 //虚拟IP支持多个.   将会配置在预设的网卡接口上
 31 
 32     }

 
 
 
 [root@web2 ~]# vim /etc/keepalived/keepalived.conf
global_defs {
  notification_email {
    admin@tarena.com.cn                //设置报警收件人邮箱
  }
  notification_email_from ka@localhost    //设置发件人
  smtp_server 127.0.0.1                //定义邮件服务器
  smtp_connect_timeout 30
  router_id  web2                        //设置路由ID号（实验需要修改）
}
vrrp_instance VI_1 {
  state BACKUP                             //备服务器为BACKUP（实验需要修改）
  interface eth0                        //定义网络接口
  virtual_router_id 50                    //主辅VRID号必须一致
  priority 50                             //服务器优先级（实验需要修改）
  advert_int 1
  authentication {
     auth_type pass
     auth_pass 1111                       //主辅服务器密码必须一致
  }
  virtual_ipaddress {  192.168.4.80  }    //谁是主服务器谁配置VIP（实验需要修改）
}


 
 
#### LVS 热备 
 
 [root@proxy1 ~]# vim /etc/keepalived/keepalived.conf
global_defs {
  notification_email {
    admin@tarena.com.cn                //设置报警收件人邮箱
  }
  notification_email_from ka@localhost    //设置发件人
  smtp_server 127.0.0.1                //定义邮件服务器
  smtp_connect_timeout 30
  router_id  lvs1                        //设置路由ID号(实验需要修改)
}
vrrp_instance VI_1 {
  state MASTER                             //主服务器为MASTER
  interface eth0                        //定义网络接口
  virtual_router_id 50                    //主辅VRID号必须一致
  priority 100                         //服务器优先级
  advert_int 1
  authentication {
    auth_type pass
    auth_pass 1111                       //主辅服务器密码必须一致
  }
  virtual_ipaddress {  192.168.4.15  }   //配置VIP（实验需要修改）
}
virtual_server 192.168.4.15 80 {           //设置ipvsadm的VIP规则（实验需要修改）
  delay_loop 6
  lb_algo wrr                          //设置LVS调度算法为WRR
  lb_kind DR                               //设置LVS的模式为DR
  #persistence_timeout 50
#注意这样的作用是保持连接，开启后，客户端在一定时间内始终访问相同服务器
  protocol TCP
  real_server 192.168.4.100 80 {         //设置后端web服务器真实IP（实验需要修改）
    weight 1                             //设置权重为1
    TCP_CHECK {                            //对后台real_server做健康检查
    connect_timeout 3
    nb_get_retry 3
    delay_before_retry 3
    }
  }
 real_server 192.168.4.200 80 {       //设置后端web服务器真实IP（实验需要修改）
    weight 2                          //设置权重为2
    TCP_CHECK {
    connect_timeout 3
    nb_get_retry 3
    delay_before_retry 3
    }
  }
}
[root@proxy1 ~]# systemctl start keepalived
[root@proxy1 ~]# ipvsadm -Ln                     #查看LVS规则
[root@proxy1 ~]# ip a  s                          #查看VIP配置

[root@proxy2 ~]# vim /etc/keepalived/keepalived.conf
global_defs {
  notification_email {
    admin@tarena.com.cn                //设置报警收件人邮箱
  }
  notification_email_from ka@localhost    //设置发件人
  smtp_server 127.0.0.1                //定义邮件服务器
  smtp_connect_timeout 30
  router_id  lvs2                        //设置路由ID号（实验需要修改）
}
vrrp_instance VI_1 {
  state BACKUP                             //从服务器为BACKUP（实验需要修改）
  interface eth0                        //定义网络接口
  virtual_router_id 50                    //主辅VRID号必须一致
  priority 50                             //服务器优先级（实验需要修改）
  advert_int 1
  authentication {
    auth_type pass
    auth_pass 1111                       //主辅服务器密码必须一致
  }
  virtual_ipaddress {  192.168.4.15  }  //设置VIP（实验需要修改）
}
virtual_server 192.168.4.15 80 {          //自动设置LVS规则（实验需要修改）
  delay_loop 6
  lb_algo wrr                          //设置LVS调度算法为WRR
  lb_kind DR                               //设置LVS的模式为DR
 # persistence_timeout 50
#注意这样的作用是保持连接，开启后，客户端在一定时间内始终访问相同服务器
  protocol TCP
  real_server 192.168.4.100 80 {        //设置后端web服务器的真实IP（实验需要修改）
    weight 1                              //设置权重为1
    TCP_CHECK {                         //对后台real_server做健康检查
    connect_timeout 3
    nb_get_retry 3
    delay_before_retry 3
    }
  }
 real_server 192.168.4.200 80 {         //设置后端web服务器的真实IP（实验需要修改）
    weight 2                              //设置权重为2
    TCP_CHECK {
    connect_timeout 3
    nb_get_retry 3
    delay_before_retry 3
    }
  }
[root@proxy2 ~]# systemctl start keepalived
[root@proxy2 ~]# ipvsadm -Ln                 #查看LVS规则
[root@proxy2 ~]# ip  a   s                    #查看VIP设置




