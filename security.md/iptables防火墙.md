# iptables防火墙
## 防火墙概述
### 什么是防火墙
一道保护性的安全屏障（保护、隔离）
### Linux包过滤防火墙
+ RHEL7默认使用firewalld作为防火墙
+ firewalld底层还是调用包过滤(ip包过滤)防火墙iptables
### 防火墙组成
+ 四张表(表是功能分类,能处理什么链的包是表决定的)
  + raw表 状态跟踪表(生成到消亡,new生成状态,已连接状态,断开连接)
  + mangle表 包标记表(一些包,传输命令和协议一样(如ssh)进行区分对待)
  + nat表 地址转换表(重点)
  + filter表 过滤表 (重点)
+ 五条链(数据包传输的方向,进入主机,从主机出去,经过主机-源和目标都不是主机)
  + INPUT链 匹配进入防火墙本机的链
  + OUTPUT 匹配从防火墙本机出去的数据包
  + FORWARD 匹配经过防火墙的主机的数据包
  + POSTROUTING 路由后 (数据包选路之后)
  + PREROUTING 路由前(数据包选路之前)
 
### 包过滤匹配流程
+ 规则链内的匹配顺序
  + 顺序比对，匹配即停止（LOG-记日志除外）
  + 若无任何匹配，则按该链的默认策略处理

## iptables用法解析

### iptables基本用法
+ 管理程序位置(命令的绝对路径)
  + /sbin/iptables
+ 指令组成
  + iptables [-t 表名] 选项 [链名] [条件] [-j 目标操作]

+ 注意事项/整体规律
  + 可以不指定表，默认为filter表
  + 可以不指定链，默认为对应表的所有链
  + 如果没有匹配规则，则使用防火墙默认规则
  + 选项/链名/目标操作作用大写字母，其余小写
### 基本的目标操作
+ ACCEPT：允许通过/放行
+ DROP：直接丢弃
+ REJECT:拒绝通过，必要时会给出提示
+ LOG：记录日志，然后传给下一条规则（“匹配即停止”规律唯一例外）

### 常用的管理选项
类别|选项|用途
---|---|---
添加规则 1|-A|在链的末尾追加一条规则
添加规则 2|-I|在链的开头（或指定序号）插入一条规则
查看规则 1|-L|列出所有规则条目
查看规则 2|-n|以数字形式显示地址、端口等
查看规则 3|- -line-numbers|查看规则时，显示规则的序号
删除规则 1|-D|删除链内指定序号（或内容）的一条规则
删除规则 2|-F|清空所有规则
默认策略|-P|为指定的链设置默认规则
## 规则管理示例
+ 添加新的规则（-A追加、-I插入）
```
~]# iptables -t filter -A INPUT -p tcp -j ACCEPT
~]# iptables -I INPUT -p udp -j ACCEPT
~]# iptables -I INPUT 2 -p icmp -j ACCEPT
```
+ 查看规则列表（-L 查看）
```
~]# iptables -nL INPUT
~]# iptables -L INPUT --line-numbers
```
+ 删除、清空规则（-D 删除、-F清空）
```
~]# iptables -D INPUT 3 
//依次清空4个表的规则
~]# iptables -F
~]# iptable -t nat -F
~]# iptable -t mangle -F
~]# iptable -t raw -F
```
+ 设置默认规则
  + 所有链的出事
+ 匹配条件
+ 扩展匹配条件

## filter表控制(主机型防火墙 和网络防火墙)
### 防护类型及条件
#### 主机/网络型防护
+ 根据保护对象(本机,其他主机)区分
  + 主机型防火墙
    + 作用位置:在服务器本机运行防火墙服务
    + filter ----->INPUT
  + 网络型防火墙
    + 作用位置:防火墙服务部署在两个网络之间
    + filter ------>FORWARD
### 开启内核的IP转发
+ 解释:一台主机能够收发来自不同网段的数据包
+ 作为网关,路由的必要条件(如何开启)
  + ``echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf``
  + ``echo 1 >/proc/sys/net/ipv4/ip_forward``
### 基本匹配条件
+ 通用匹配
  + 可直接使用.不依赖于其他条件或扩展
  + 包括网络协议,IP地址,网络接口等条件
+ 隐含匹配
  + 要求以特定的协议匹配作为前提
  + 包括,TCP标记,ICMP类型等条件
+ 用法:(需要取反条件时,用叹号!)
  选项|用法
  ---|---
  协议匹配|-p 协议名
  地址配置|-s 源地址,-d目标地址
  接口协议|-i 收数据的网卡,-o 发数据的网卡
  端口配置|--sport 源端口,--dport 目标端口
  ICMP类型匹配|--icmp-type ICMP类型
## 过滤规则示例
### 封禁IP地址/网段
+ 主机防护,针对入站访问的源地址
+ 网络防护,针对转发访问的地址
### 保护特定网络服务
### 禁ping相关策略处理
示例:(允许本机ping其他主机,但是禁止其他主机ping本机)
方法一:
```
//ping 别人的时候 包的类型是request 禁止别人ping
自己
~]# iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
//不是请求的(回应的)允许进,ping别人,包从本机出去
~]# iptables -A INPUT -p icmp ! --icmp-type echo-request -j ACCEPT

~]# iptables -A OUTPUT -p icmp --icmp-type echo-requset -j ACCEPT
~] # iptables -A OUTPUT -p icmp ! --icmp-type echo-request -j DROP  
```
方法二:
ping 命令的回应包 echo-replay
ping 命令的请求包类型 echo-request
```
//设置默认不让进之后再进行如下设置
~]# iptables -t filter -A INPUT -p icmp --icmp-type echo-replay -j ACCEPT
```
## 扩展匹配
### 扩展条件概述
#### 扩展条件的方法
+ 前提条件
  + 有对应的防火墙模块支持
+ 基本用法
  + -m 扩展模块 --扩展条件 条件值
  + 示例:```-m mac --mac-source 00:0C:29:74:BE:21```
#### 常见的扩展条件类型
选项|用法
---|---
MAC地址匹配地址|-m mac --mac-source MAC地址
多端口匹配 1|-m multiport --sports 源端口列表
多端口匹配 2|-m multiport --dports 目标端口列表
IP范围匹配 1 |-m iprange --src-range IP1-IP2
IP范围匹配 2 |-m iprange --dst-range IP1-IP2


### 扩展案例
#### 根据MAC地址封锁主机
使用与交换网络,针对源MAC,不管其IP变成对少
```
~}# iptables -A INPUT -m mac -mac-source 00:0C:29:74:BE:21 -j DROP
```
#### 多端口案例
一条规则开放多个端口,比如Web,Mail,SSH 等
```
~]# iptables -A INPUT -P tcp -m multiport --drop 20:22,25,80,443,16800 -j ACCEPT
```
#### 根据IP范围封锁主机

ssh登录ip范围控制
允许从192.168.4.10-192.168.4.20登录
禁止从192.168.4.0/24 网段其他的主机登录
```
~]# iptables -A INPUT -p tcp --dport 22 -m iprange --scr-ange 192.168.4.10-192.168.4.20 -j ACCECP
~]# iptables -A INPUT -p tcp --dporp 22 -s 192.168.4.0/24 -j DROP
```

## nat表典型引用 
net所有局域网内容的主机共享同一个公网ip地址上网
### NAT转换原理
#### 私有地址的局限性
从局域网访问互联网的时候


#### SNAT源地址转换
### SNAT策略应用
#### 案例环境
#### 配置SAN共享上网
#### 地址伪装策略
nat ----->POSTROUTING
