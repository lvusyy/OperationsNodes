#mysql 读写分离
#### 读写分离原理
	多台mysql服务器
    	- 分别提供读,写服务,均衡流量
        - 通过主从复制保持数据一致性
    由Mysql代理面向客户端
    	- 收到sql写请求时,交给服务器a处理
        - 收到sql请求时,交给服务器B处理
        - 具体区分策略由服务设置
    先要做好主从同步
    使用maxscale服务

	vim /etc/maxscale.cnf
    
    [maxscale]
    threads=auto
    
    [server1]
    type=server
    address=192.168.4.51
    port=3306
    protocol=MySQLBackend

    [server2]
    type=server
    address=192.168.4.52
    port=3306
    protocol=MySQLBackend

    [Read-Write Service]
    type=service
    router=readwritesplit
    servers=server1,server2
    user=scaluser
    passwd=123123
    max_slave_connections=100%


    [MaxAdmin Listener]
    type=listener
    service=MaxAdmin Service
    protocol=maxscaled
    socket=default
    port=4016


	根据配置文件的定义 
    	监控用户 
        grant replication slave ,replication client on *.* to scalemon@'%' identified by "123123";
        
        路由用户
        grant select on mysql.* to scaluser@'%' identified by "123123";
#### 多实例
		什么是多实例
        	- 在一台物理主机上运行多个数据库服务
        为什么要使用多实例
        	- 节约运维成本
        	- 提高营救利用率
        
        配置步骤
        	1) 安装支持多实例服务的软件包
            	- 下载 
            	  mysql-5.7.20.linux-glibc2.12-x86_64.tar.gz
                - 解压
                - 移动到 /usr/local/mysql
                - 调整PATH变量
                	export PATH=/usr/local/mysql/bin:$PATH
                    source /etc/profile
            2) 修改主配置文件
            	主配置文件/etc/my.cnf
                	- 每个实例要有独立的数据库目录和监听端口号
                	- 每个实例要有独立的实例名称和独立的sock文件
                
                [mysqld_multi]								//启动多实例
                	mysqld=/usr/local/mysql/bin/mysqld_safe //指定进程文件路径
                    mysqladmin=/usr/local/mysql/bin/mysqladmin //指定管理命令路径
                    user=root
                    
                [mysqlX]				//是咧进程名称,X表示实例编号,如[mysql2]
                port=3307 				//端口号
                datadir=/data3307		//数据库目录,要手动创建
                socket=/data3307/mysql.sock		//指定sock文件的路径和名称
                pid-file=/data3307/mysqld.pid	//进程pid号文件位置
                log-error=/data3307/mysqld.err	//错误日志文件位置
             
            3) 初始化授权库
            	./mysqld --user=mysql --basedir=/usr/local/mysql/ --datadir=/data3307 --initialize   
            4) 启动服务
            	启动实例进程
                mysqld_multi start mysqlX
                停止实例进程
                ./mysqld_multi --user=root --password=密码 stop mysqlX //实例编号名称
            5) 客户端访问测试
            	本机链接
                	- 使用初始密码链接
            			./mysql -uroot -p初始化密码 -S sock文件
                    - 修改本机登录密码
                    - 	alter user user() identified by "新密码" ;
                    - 链接实例
                    -	./mysql -uroot -p新密码 -S sock文件;
                    
            
### MySQL性能调优

		 客户端
           ↓
        链接/线程处理
		   ↓       ↓
		查询缓存 ← 分析器
        			↓
                优化器
         存储引擎