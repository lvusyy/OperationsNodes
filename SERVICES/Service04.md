### PXE 网络装机

#### 1. 部署DHCP服务器
		Dynamic Host Configuration Protocol
	> DHCP概述及原理
		动态主机配置协议,由IETF(Internet 网络工程师任务小组) 组织制定,用来简化主机地址分配管理
		主要参数
		ip地址/子网掩码/广播地址
		默认网关地址,DNS服务器地址
		pxe引导设置(TFTP服务器地址,引导文件名)


		原理:
		      DHCP地址分配的四次会话
			DISCOVERY---->OFFER--->REQUEST----->ACK
		服务端基本概念
			租期:  允许客户机租用IP地址的时间,单位为 秒
			作用域:分配给和户籍的IP地址所在的网段
			地址池:用来动态分配的IP地址的范围
	> 配置
		
		软件包:dhcp
		配置文件:/etc/dhcp/dhcpd.conf
		起服务 dhcp
		
		vim /etc/dhcp/dhcpd.conf
		----
		subnet 192.168.4.0 netmask 255.255.255.0 {
			range 192.168.4.10 192.168.4.200;
			option domain-name-servers 192.168.4.7;
			option routers 192.168.4.7;			
			next-server 192.168.4.7;
			filename "pxelinux.0";
			default-lease-time 600;			
			max-lease-time 7200;
			
		}
		启服务
		确认服务状态
		`netstat -antpu |grep dhcpd`

####	2. pxe网络装机
	规模化:同时装备多台主机
	自动化:装系统,配置服务
	自动实现,不需要其它介质.u盘.光盘之类

	pxe pre-boot eXecution Environment
	- 预启动执行环境,在操作系统之前运行
	- 可用于远程安装
	工作模式
		- pxe client 集成在网卡的启动芯片中
		- 当计算机引导式,从网卡芯片中吧PXE client调入内存
		执行,获取pxe server 配置,显示菜单,根据用户选择将远程引导程序下载到本机运行


		dhcp -->tftp -->http
		pxelinux.0 网络安装说明书,二进制文件,安装一个软件产生

####	3. tftp 简单的文件传输协议
		包:tftp-server
		服务名:tftpd
		重新启动
####   4. syslinux 
		查找pxeLinux在那个包中
			yum provides */pxelinux.0
		安装 syslinux
			yum -y install syslinux
		寻找pxelinux.0
			rpm -ql syslinux
		cp $pxelinux /var/lib/tftpboot/

####	5. 配置pxelinux.0 的菜单
			/var/lib/tftpboot/pxelinux.cfg/default
			cp /mnt/isolinux/isolinux.cf /var/lib/tftpboot/pxelinux.cfg/default
####	6. 配置图形模块与背景图片
			cp /mnt/isolinux/splash.png /mnt/isolinux/vesamenu.c32 /var/lib/tftpboot/

####	7. 部署启动内容预启动所需的驱动程序
		启动内核
			cp /mnt/isolinux/initrd.img /mnt/isolinux/vmlinuz /var/lib/tftpboot/ 

		修改启动菜单
		删除多余label	
		调整已存在label
		设置默认label
		
	    ```label linux
		 menu label Install RHEL 7.4
		 menu default
		 kernel vmlinuz
		 append initrd=initrd.img```
				                       `
	8. http指向到镜像
		mount dvd  /var/html/www/rhel7/
		yum install httpd
		
	9. 安装自动应答软件
		包:system-config-kickstart
		system-config-kickstart
		修改 yum 的源名为  development
		[development]

		配置kickstart 
			配置时区.按需配置

	10. 修改菜单文件,指定KS应答文件位置
		append initrd=initrd.img  ks=http://192.168.4.7/ks.cfg
