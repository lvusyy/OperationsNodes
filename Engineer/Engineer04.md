#!/bin/bash
#### 课程回顾


#### smb共享服务
	- 跨平台的共享 Windows与Linux
	- 用途:为客户家提供共享使用的文件夹
	- 协议:SMB(TCP :139 验证),CIFS(TCP :445 传输数据)
	- 软件包:samba
	- 系统服务:smb
	- 配置文件://etc/samba/smb.conf
       管理共享账号
	- samba用户         专门用来访问共享文件夹的用户
	  采用独立设置的密码
	  但需要提前建立同名的系统用户(可以不设置密码)
	
	pdbedit 管理用户
	  - 添加用户:pdbedit -a 用户名称
	  - 查询用户:pdbedit -L [用户名]
	  - 删除用户:pdbedit -x 用户名
	
	修改文件及参数

	[自定共享名]
	path=文件夹绝对路径
	; public =no|yes //默认no 与Windows的guest来宾用户有关
	; browseable=yes|no //默认
	; read only=yes|no
	; write list=用户1 用户2
	; valid users=用户1 用户2
	; hosts allow=客户机地址 ..
	; hosts deny=客户机地址 ..
	客户端链接
	安装包  samba-client
	客户端命令 smbclient -L 服务的IP
	    链接   smbclient -U server 
	
	软件包 cifs-utils
	> mount 支持cifs协议及向相应的文件系统
	  yum install -y cifs-utils
	mount //172.25.0.11/common /smb -o username=kenji,password=111 -t cifs
	
	/etc/fstab
	---------
	//172.25.0.11/common /smb cifs default,username=kenji,password=111,_netdev 0 0                
	#_netdev 声明网络设备,在挂载该设备时,需要配置好本机IP地址及网络服务正常才能挂载本设备
	--------
	
	*修改SElinux策略*
 		布尔值,安全上下文,非默认端口开放
		
		布尔值:getsebool -a #获取所有bool
		       setsebool samba_export_all_ro on #配置bool ro 只读
			setsebool -P .... #永久配置
			semanage boolean --list #查看bool

	发布一个可读写的服务,用户:chihiro
		
		1. 创建目录 客户端,服务端
		`mkdir devops &&echo abc>/devops/a.txt`
		
		2. 修改配置文件 /etc/samba/smb.conf
		`[devops]		#共享名称
		  path=/devops		#共享路径
		  write list=chihiro` #允许chihiro用户可以写入
		
		3. 修改SELinux的boolean 使之可以读写

		  semanage boolean --modify samba_export_all_rw -o
		  setsebool -P samba_export_all_rw on
	
		4. 修改服务端Linux目录的读写执行权限
			chmod chown setfacl
		4. 客户端挂载/开机自动挂载
		  	mount //172.25.0.11/devops /devops -t cifs -o defaults,username=chihiro,password=111,_netdev

	增加多用户的支持 multiuser
		目的:临时切换用户身份,达成特定目标
		1.客户端在挂载的参数上增加multiuser,sec=ntlmssp (提供NT局域网管理安全支持)
		//172.25.0.11/devops /devops/ cifs username=kenji,password=111,multiuser,sec=ntlmssp
		2.切换到普通用户
		3. cifscreds add|update -u 共享用户名 服务器地址
		`cifscreds add -u chihiro server0`
		 > 输入密码
		4.用新用户操作完成后之后,退出本地的普通用户即可



	### NFS共享 (network file server)
		用途:为客户机提供共享使用的文件夹
		协议:NFS(TCP/UDP 2049),RPC(TCP/UDP 111)
		 软件包:nfs-utils
		 系统服务名:nfs-server
	
		1.安装包.
		 `yum install -f nfs-utils`
		2.创建共享目录
		  `mkdir /nfs &&echo haha >/nfs/1.txt`
		3.修改配置文件
		   `vim /etc/exports`
		   #共享的路径 客户机地址(权限) 客户机地址(权限) ...
			`/nfs *(ro)`
			`/nfs 172.25.0.0/24(ro)`
		4. 启动服务
			`systemctl restart nfs-server`
		5. 客户端挂载
			mount 172.25.0.10:/nfs /nfs -o defaults,_netdev,ro -t nfs
		6. 客户端列出NFS共享资源
			showmount --export 服务器地址
	### IPv6 
		- 128个二进制位,冒号分隔,用十六进制表示
		- 每段内连续的前置 0 可以省略,连续的多个 : 可简化为 ::
		- 列 2003:ac18:0000:0000:0000:0000:0000:0305
		- 简化  2003:ac18::305/64``			````````````````````````````````````````````````````````````````````````		
