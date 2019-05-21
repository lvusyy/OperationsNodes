#### crontab 定时任务
用途:安装设置的时间间隔为用户反复执行某一项固定的系统任务  
  软件包:cronie,crontabs  
  系统服务:crond
  日志文件:/var/log/crond

    配置文件
        `/var/pool/cron/`  存放每个用户包括root的任务,创建者的名字命名
        `/etc/crontab` 系统管理员指定的维护系统以及其他任务的crontab
        分 时 日 月 周 任务命令(绝对路径)
        0
        1-3
        1,2,3
        分钟位置不能用* 不适用可以用0
        日期匹配会尽量满足每个条件

        \*/4 每4(分,时,日,月,周)

匹配范围  
\*:匹配范围内任意时间  
,:分隔多个不连续的时间点  
-:指定连续时间分为  
/n:指定时间频率,每n ...  

- 编辑 crontab -e [-u 用户]
- 查看 crontab -l [-u 用户]
- 清除 crontab -r [-u 用户]


        SHELL=/bin/bash  
        PATH=/sbin:/bin:/usr/sbin:/usr/bin
        MAILTO=root
        HOME=/
        # .---------------- minute (0 - 59)
        # | .------------- hour (0 - 23)
        # | | .---------- day of month (1 - 31)
        # | | | .------- month (1 - 12) OR jan,feb,mar,apr ...
        # | | | | .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
        # | | | | |
        # * * * * * user-name command to be executed  

    `crontab -e` 编辑


*权限的分类*  
>基本权限 附加权限 acl  

1. ### 权限和归属  

  *访问方式(权限)*
  - 读取:允许查看内容 read r
  - 写入:允许修改内容 write w
  - 可执行:允许运行和切换 execute x  
   **一旦设置过acl权限,目录的属组的权限位上会显示mask的权限.而真实的权限用getfacl 查看group的权限**
  *权限使用对象*
    *惰性匹配,匹配第一个*  
    *所有者>所属组>其它*  
  - 所有者: 目录或文件的所有者 -user u
  - 所属组: 拥有此文件或目录的组 -group g
  - 其他用户: 除所有者,所属组以外的用户 -other o

  lrwxrwxrwx. 1 root root 13 5月   7 2014 /etc/rc.local -> rc.d/rc.local
  1. l 代表 link - 普通文件 d 目录 c字符设备 s socket p 管道
  2. 所有者的rwx 位
  - 所属组的 rwx 位
  - 其它人的 rwx 位
  - . 代表 没有附加权限
  - 1 硬链接数
  - 所有者名字
  - 所属组名字
  - 大小
  - 最后修改时间
  - 文件名

- ### 修改权限  
   *目录的 r 权限:能够ls浏览此目录内容*
   *目录的 w 权限: 能够更改目录内容的操作*
   *目录的 x 权限: 能够cd进去*
  - `chmod` 修改文件或目录权限  
      1. [-R 递归修改] [ugo 对象] [+-= 操作符] [rwx 权限] 文件名或目录
      2. [-R 递归修改] [777] 文件或目录  
        *r = 4 (2^2) w = 2 (2^1) x = 1 (2^0)*  
        *[777] 第一个7代表u 第二个7代表g 第三个代表o*
	
	*特殊权限:suid 4,sgid 2,sbit 1  *
	*2770 第一位代表特殊权限位*

  - `chown` 修改所有者  
      [-R 递归修改] :属组  文件或目录  
      [-R 递归修改] 属主  文件或目录  
      [-R 递归修改] 属主:属组  文件或目录  

  - `chgrp` 修改所属组  
      [-R 递归修改] 组名 +-=权限类别 文件或目录
  - `umask` 查看或修改文件掩码    
      新建文件夹默认权限=0666-权限掩码  
      新建目录默认权限=0777-权限掩码  
      超级用户默认掩码值为0022，普通用户默认为0002  
      `# umask   //查看`  
      `# umask 044//设置 `  

    Linux 碰到用户具备的权限:
      1.判断用户对于文档的权限
      2.判断所属组对于文档的权限

- ### 附加权限(特殊权限)
  > 附加在所属组的x位上  
  >>属组的权限标识会变为s  (rwx -> s,rw- -> S)
  适用于目录,Set GID可以是目录下新增的文档自动设置与父目录相同的属组
  *如果原来x为是拥有执行权限是 标识会变为s,如果没有x权限 标识就变为S*
  >附加在所有者的x位上 只对二进制文件有效.
  >>当其它用户是执行 setUid 二进制文件时会使用所有者权限操作.运行之后会释放
  >>/usr/bin/passwd

- ### acl 访问控制列表 (access control list)
  *受支持的文件系统 ext3 ext4 xfs*  

    - acl策略的作用
      - 能够对个别用户,个别组设置权限
      - 大多数挂载 ext3 ext4 xfs 文件系统默认支持

    *影响标志位的*
      lrwxrwxrwx`+` 1 root root 13 5月   7 2014 /etc/rc.local
    - 设置权限
        setfacl -m [u:dc]:rx [g:root]:rwx  /NB

    - 查看权限
        getfacl /NB
    - 删除指定用户的ACL
        setfacl -x u:lisi /home/lisi
    - 清除权限
        setfacl -b /home/lisi
    - 拉黑用户
        setfacl -m u:root:--- /home/lisi


    RHCSA(红帽认证的管理员)
    RHCE(红帽认证的工程师)
    RHCA(红帽认证的架构师)


### 使用LDAP认证 (lightweight Directory Access Protocol)
    LDAP用户:网络用户,由网络中LDAP服务器统一提供用户信息


    加入LDAP域

    LDAP服务器:虚拟机classroom

    LDAP客户端:虚拟机server
    1. 安装软件sssd,客户端与LDAP服务器沟通
    sssd 软件包
    图形化配合软件包
    authconfig-gtk
    dc=example,dc=com #指定服务端yum
    classroom.example.com #指定服务端主机名
    勾选TLS加密
    下载证书
    http://classroom.example.com/pub/example-ca.crt
    选择LDAP密码
----
    家目录漫游
    将classroom上的家目录漫游到客户端

    nfs (Network File System) 网络文件系统
    - 由nfs服务器将指定的文件夹共享给客户机


    客户端虚拟机server:访问共享

    showmount -e [服务器地址]

    `[root@server0 ~]# showmount -e classroom.example.com
    Export list for classroom.example.com:
    /home/guests 172.25.0.0/255.255.0.0`

    `mount classroom.example.com:/home/guests /home/guests`
