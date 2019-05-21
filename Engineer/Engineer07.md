#### 综合练习

  安全的web服务
    - 公钥:主要用来加密数据
    - 私钥:主要用来解密数据(与相应的公钥匹配)
    - 数字证书:证明拥有这的合法性/权威性(单位名称,有效期,公钥,颁发架构签名,...)
    - Certificate Authority,数字证书授权中心:负责证书的申请/审核/颁发/撤销等管理工作


  #### 实现htpps的加密条件
	- HTTP加密web通信(TCP 443端口)
	- Secure Sockets Layer, 安全套接字层
	- Transport Layer Security, 安全传输层协议
       实现
	1. 启用ssl模块支持
		yum -y install mod_ssl
		配置文件
		vim /etc/httpd/conf.d/ssl.conf
		证书,秘钥相关文件
		/etc/pki/tls/certs/证书文件.crt
		/etc/pki/tls/private/私钥文件.key

	2. 数字证书,私钥,根证书(ca管理机构的证书)
	
	3. 配置的实现
		vim	/etc/httpd/conf.d/ssl.conf
		<VirtualHost _default_:443>
		  DocumentRoot "/var/www/html"
		  ServerName server0.example.com:443
		  ...
		  
                  SSLCertificateFile /etc/pki/tls/certs/server0.crt
		  SSLCertificateKeyFile /etc/pki/tls/private/server0.key
		  SSLCACertificateFile /etc/pki/tls/certs/example-ca.crt
		</VirtualHost>

		`systemctl restart httpd`



	##### 邮件服务 
		包:postfix
		配置文件:/etc/postfix/main.cf
			1. 配置文件的配置
			myorigin = server0.example.com
			inet_interfaces = all	#代表所有网络都提供邮件功能
			mydestination = server0.example.com #判定收件人域名后缀 为本域邮件.			
			destination 目标

			2. 创建普通用户测试邮件收发
				发送
				mail -s "标题" -r 发件人 收件人
				正文1
				正文
				.
				EOF
				接收
				mail -u 收件人
	#### parted分区工具
		* 使用fdisk操作>2.2tb的磁盘时超出容量的磁盘将会无法识别,导致分区失效.

		- GPT: 最多可以划分128主分区
		-      最大空间支持18EB
			tb pb eb 

		mktable gpt 重建分区表
		mkpart 分区名 文件系统 起始位置 结束分区
	

	#### 配置聚合链接(链路聚合 网卡组队网卡绑定) 
		
		team,聚合链接(也称为链路聚合)
		- 由多块网卡(team-slave)一起组件而成的虚拟网卡,及组队
		- 作用1:轮讯是(roundrobin) 的流量负载均衡
		- 作用2:热备份(activebackup)链接冗余
		
			man teamd.conf
			
		实现链路聚合的条件
		  - 2块或2块以上的物理网卡
		  ifconfig -a |igrep ^eth
		创建虚拟接口

		  nmcli connection add type team con-name team0 ifname team0 autoconnect yes config '{"runner":{"name":"activebackup"}}'		
		
		创建team的成员
		  nmcli connection add type team-slave con-name team0-1 ifname eth0 master team0
		   nmcli connecton add type team-slave con-name team0-2 ifname eth1 master team0
		    
		配置接口的IP地址
		  nmcli connection modify team0 ipv4.method manual ipv4.address '192.168.1.1/24' connection.autoconnect yes
		   nmcli connection up team0 
		up接口	
		   nmcli connection up team0
		   nmcli connection up team0-1
		   nmcli connection up team0-2
		
		down接口
		    nmcli connection down team0-1
		    nmcli connection down team0-2		
		删除接口:
		    nmcli connection delete 'team0'
			
