#### Web通信基本概念
	基于B/S(Browser/Server)架构的网页服务
		- 服务端提供网页
		- 浏览器下载并显示网页
	Hyper Text Markup Language,超文本标记语言
	Hyper Text Transfer Protocol ,超文本传输协议

	apache服务
	软件包:httpd
	服务名称:httpd
	配置文件:/etc/httpd/conf/httpd.conf 
	  默认配置:
		    监听端口:80
		    ServerName:本站点注册的DNS名称(空缺) 
		    DocumentRoot:网页根目录(/var/www/html)
		    DirectoryIndex:起始页/首页文件名(index.html)
	
	自定义配置目录:
		/etc/httpd/conf.d/*.conf	
		权限配置
		<Directory />
			#	all denied|granted
			Require ip 172.25.0.11
		</Direcory>
		#wsgi  yum install mod_wsgi
		WsgiScriptAlias / /var/www/qq/webinfo.wsgi

	selinux 修改上下文标签
		chcon -R --referemce=/var/www /webroot
	
	网络路径与服务器实际存放路径


	虚拟Web主机
	  - 由同一台服务器提供多个不同的Web站点
 	  - 一旦使用了虚拟Web主机的功能,所有的站点都必须要使用虚拟web主机功能
	)))))))))))))))))))))))))))))))))))))))
	端口的优先级大于域名,优先匹配端口
	(((((((((((((((((((((((((((((((((((((((
	ooooooooooooooooooooooooooo
	列出所有的selinux用户
       # semanage user -l
	显示所有的selinux登录
       # semanage login -l
	改变vmlinux登录为staff_u
       # semanage login -a -s staff_u vmlinux
	改变组clerks登录为user_u
        # semanage login -a -s user_u %clerks
	改变上下文fcontext
	添加文件上下文到/web下的所有
       # semanage fcontext -a -t httpd_sys_content_t "/web(/.*)?"
	恢复
       # restorecon -R -v /web
	用/home 替换/home1上下文
       # semanage fcontext -a -e /home /home1
       # restorecon -R -v /home1
	家目录在高级目录下。例如/disk6/home,用/home替换其上下文
       # semanage fcontext -a -t home_root_t "/disk6"
       # semanage fcontext -a -e /home /disk6/home
       # restorecon -R -v /disk6
       端口的上下文
	允许Apache监听tcp 81端口
       # semanage port -a -t http_port_t -p tcp 81
	切换apache到permissive域
       # semanage permissive -a httpd_t
       关闭dontaudit规则
       # semanage dontaudit off
     管理多台机器
	多台机器需要同样的自定义上下文。具体做法，将自定义上下文从第一台电脑上抽取出来，复制他们到第二台机器，然后输出就可以了

       # semanage -o /tmp/local.selinux
       # scp /tmp/local.selinux ip:/tmp
       # ssh secondmachine
       # semanage -i /tmp/local.selinux
	如果在自定义中存在上下文，需要用serestorecon来恢复
