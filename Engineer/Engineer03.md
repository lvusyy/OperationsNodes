#### 课程回顾

### SELinux安全机制
	+ Security-Enhanced Linux
	   美国NSA国家安全局主导开发,一套增强Linux系统安全的强制访问控制体系
	   集成到Linux内核(2.6及以上)中运行
	  RHEL7基于SELinux体系中针对用户,进程,目录和文件
	提供了预设的保护策略,以及管理工具
	

	+ SElinux运行模式切换
	  - SELinux的运行模式
		- enforcing(强制)
		- permissive(宽松)
		- disabled(彻底禁用)


	  切换运行模式
		- 临时切换 setenforce 1/0 (强制/宽松 切换)
		- 查看当前模式 getenforce
		- 固定配置 /etc/selinux/config	
		- 切换disabled状态,必须重新启动
		
### 防火墙策略基本使用


	- 搭建基本Web服务
	  - 装包启动服务
		yum install -y httpd
		systemctl start httpd
		systemctl enable httpd
		
		
	  -写一个页面文件
		默认页面名称	/var/www/html
		默认网页文件名称 index.html
	  - 搭建基本的ftp服务
	    - 装包启动服务
		yum install -y vsftpd
		systemctl start vsftpd
		systemctl enable vsftpd
	    - 默认路径
		共享文件路径 /var/ftp/
		配置文件路径 /etc/vsftpd/

	- 防火墙基本作用:隔离过滤
	- 防火墙种类:硬件防火墙,软件防火墙
	firewalld服务基础
	管理工具:firewall-cmd,firewall-config
	服务相关操作
		systemctl restart firewalld
		systemctl enable firewalld
	
	- 根据所在的该网络场所区分,预设保护规则集
		- public: 仅允许本机的sshd dhcp ping 等少数 查看trusted 信任区
		- trusted: 允许任何访问                     查看block和drop 阻隔区
		- block: 阻塞任何来访请求(明确拒绝,会给回应) 默认查看trusted
		- drop: 丢弃任何来访的数据包(直接丢弃,不给回应) 默认查看 trusted 区域
	防火墙判定规则
	1.查看客户端请求中,源IP地址然后查阅自己那个区域,有该IP地址的规则,则进入该区域
	2.进入默认区域(public)


	- 配置规则的位置
	  - 运行时(runtime)
		*临时设置防火墙*
		切换默认区域(zone)
		firewall-cmd --set-default-zone=[public/truesed/block/drop] #默认永久
		查看默认区域
		firewall-cmd --get-default-zone
		在区域中添加数据
		firewall-cmd --zone=public --add-port=80/tcp
		firewall-cmd --zone=block --remove-service=ftp
	  - 永久(permanent)
		只需要在原来命令上加上 ---permanent 即可
		firewal-cmd --zone=public --add-service=ssh --permanent #需要重载配置才生效
		
		#重新载入配置
		firewall-cmd --reload

	常见协议
	http,https,smtp,pop3,dns,dhcp,ftp,tftp,ssh,telnet,snmp
	80    443      25  110     53 67/68 21/20 69   22   23        161
	
	- 配置拒绝指定IP
		firewall-cmd --zone=block --add-source=172.25.0.10
	- 实现本机的端口映射
		firewall-cmd --permanent --add-forward-port=port=5423:proto=tcp:toport=80
		firewall-cmd --reload
		
