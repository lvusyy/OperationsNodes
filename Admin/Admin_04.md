#### 教学环境介绍

gnome 配置  
- dconf read  
      write \  "['key:value']"  
      dconf update  

- gsettings  
>    help                      显示此信息  
    list-schemas              列出安装了的方案  
    list-relocatable-schemas  列出可重定向的方案  
    list-keys                 列出某个方案中的键  
    list-children             列出某个方案的子对象  
    list-recursively          递归地列出键和值  
    range                     查询某个键的范围  
    describe                  查询某个键的描述  
    get                       获取某个键值  
    set                       设置某个键值  
    reset                     重设某个键值  
    reset-recursively         重设指定方案中的所有值  
    writable                  检查某个键是否可写  
    monitor                   监视更改  

dconf 配置文件  
`/etc/dconf/db/*.d/locks/` 锁定配置字段 使之 gsettings dconf 无法改变


- server 练习用服务器
- desktop 练习用客户机
- classroom 提供网关/dns/软件素材等资源

还原虚拟机  
    `rht-vmctl reset classroom`  
    `rht-vmctl reset server`  
    `rht-vmctl reset desktop`  


#### 基本操作
虚拟机Server:
  - 查看系统版本:RHEL7
  - 查看系统主机名:server0.example.com
  - 查看系统的eth0的ip地址:172.25.0.11/24

虚拟机Desktop:
  - 查看系统版本:RHEL7
  - 查看系统主机名:desktop0.example.com
  - 查看系统的eth0的ip地址:172.25.0.10/24

虚拟机Classroom:
  - 查看系统版本:RHEL7
  - 查看系统主机名:classroom.example.com
  - 查看系统的eth0的ip地址:172.25.0.254/24


#### 远程管理虚拟机
ssh [参数] [用户名@]对方ip

ssh -X  [用户名@]对方ip  图形界面连接对方

设置常用的别名
修改配置文件
`vim ~/.bashrc`

#### 零散软件管理
1.获得软件包
虚拟机lassroom 提供RHEL7.0光盘所有软件包
http 超文本传输

访问
classroom.example.com

### rpm
`rpm -i` 安装软件包 --nodeps 不严重软件包的依赖  
`rpm -q 包名` 查询软件包 退出用来看下还未安装的软件包  
`rpm -f 文件名` 查询文件所属于的软件包  
`rpm -a ` 查询所有已经安装的软件包  
`rpm -v` 可视化  
`rpm -h` 显示安装进度  
`rpm -U` 升级  
`rpm -e` 卸载  
`rpm -ql` 列出一个rpm包安装的文件  

##### 导入签名  
wget ..../RPM-GPG-KEY-redhat-release  
rpm --import RPM-GPG-KEY-redhat-release


### 升级内核
+ 下载内核
  wget ../RHEL7/x86_64/errata/Packages/kernel*.rpm

  包依赖关系 rpm 无法自动解决  
  yum 自动解决依赖关系安装软件

服务端:虚拟机classroom
>1.众多的软件包2.仓库数据文件 3.具备光盘所有内容  
4.搭建ftp服务或web服务,共享光盘内容

客户端:虚拟机server
书写yum客户端配置文件,指定服务端位置
目录: `/etc/yum.repos.d/`
文件: `*.repo`
需要规范配置.

自动配置客户端配置
yum-config-manager --add-repo http://classroom.example.com/content/rhel7.0/x86_64/dvd/


yum客户端配置
`/etc/yum.repos.d/????.repo`
```
[RHEL7]
#名称
name=redhat
baseurl=http://classroom.example.com/content/rhel7.0/x86_64/dvd/
#本配置文件启用
enable=1
#检测包的签名认证
gpgcheck=1
```


`yum　 repolist` 列出包列表
`yum remove `卸载软件包
`yum　clean all` 清理缓存



### 网络篇
#### 配置永就的主机名
vim /etc/hostname
#### 配置永就的IP地址,子网掩码,网关地址
网卡配置文件
vim /etc/sysconfig/network-scripts/ifcfg-eth0
  - nmcli配置 (Network Manager Command Line Interface)
    `nmcli connection show` 显示网卡接口
    `nmcli connection modify 'System eth0' ipv4.method manual ipv4.addresses '172.25.0.110/24 172.25.0.254' connection.autoconnect yes `
    `nmcli connection up 'System eth0'` 启动配置

  - nmtui 图形化配置
