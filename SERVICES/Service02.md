#### DNS服务器
        正向解析
	反向解析
      根域名 .
      一级域名 .cn ,us .hk .tw .jp .kr
      二级域名 .com.cn .edu.cn .org.cn .net.cn
      三级域名 .qq.com.cn sina.com.cn
      完整合格的主机名 www.qq.com.cn ftp.qq.com 主机头部+域名
	
	BIND(Berkeley Internet Name Daemon)
	  - 伯克利 Internet 域名服务
	  - https://www.isc.org/
			(bind-chroot 牢笼策略)
 	  包名:bind bind-chroot
	  /usr/sbin/named
	  named
	  tcp/udp 53
	  运行时的虚拟根环境:/var/named/chroot/
	  主配置文件:/etc/named.conf   #设置负责解析的域名
	  地址库文件:/var/named/	#主机名与IP地址的对应关系
	  * 全局配置部分
            	所有域名必须以点结尾
		- 设置监听地址/端口,地址库存放位置等
		/etc/named.conf
		    option{
			listen-on port 53 { 192.168.4.7;}; //监听地址和端口
			directory "/var/named";
			allow-query { any; };
			recursion yes; 运行递归查询
			...
			//listen-on-v6 port 53 { ::1; };
			//Include "/etc/named.rfc1912.zones", //可载入其他配置
			}
	
		vim /var/named/tedu.cn.zone
		#以点结尾
		#不以结尾会自动补全的
		
			$TTL 1D
			@       IN SOA  @ rname.invalid. (
                                        0       ; serial
                                        1D      ; refresh
                                        1H      ; retry
                                        1W      ; expire
                                        3H )    ; minimum
			tedu.cn.        NS      svr7.tedu.cn.      ;
			svr7.tedu.cn.   A       192.168.4.7
			www             A       192.168.4.1
			ftp             A       192.168.4.2
			svr7            AAAA    ::1
			pc207           A       192.168.4.207
			*		    A       192.168.4.7      ;通配那些不存在的host
			tts		    CNAME   pc207            ;别名
			
			;有规律的泛解析
			$GENERATE 1-50 pc$.tedu.cn IN A 192.168.4.$

		装包,改配置,启服务	     
		重新启动服务

		### dns子域授权
			让父域的DNS服务器,可以解析子域DNS负责的域名			
			
			
			实验环境
			父域:www.qq.cvom     虚拟机a来解析
			 子域名	NS      域名
			域名		A       ip

			bj.qq.com	NS      pc207
			pc207		A	  192.168.0.1

			子域:www.bj.qq.com	 虚拟机b来解析

			正常配置即可,不需要特殊标识

	#### 主机名映射文件 /etc/hosts
		只为本机直接提供解析结果

	### 缓存dns服务器:
		缓存解析记录,加快解析
