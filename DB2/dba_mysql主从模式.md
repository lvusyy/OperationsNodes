#				mysql主从同步
### 什么是mysql主从同步?

### 修改mysql的uuid
	1.先查看mysql数据库的目录
		show variables like "datadir";
	2.生成新的uuid
		select uuid()
	3.修改配置文件达到修改mysqlUUID的目的
		vim mysql数据库目录/auto.cnf
		[auto]
		server-uuid=831e3a30-34d5-11e9-aca5-525400d1506f


### my.cnf 同步参数
    replicate-do-db = db1 #需要同步的数据库名。如果不指明同步哪些库，就去掉这行，表示所有库的同步（除了ignore忽略的库）。
    replicate-wild-do-table = db1.haha       //当只同步几个或少数表时，可以这样设置。注意这要跟上面的库指定配合使用；
    replicate-do-db = test
    replicate-wild-do-table = db1.heihei      //如果同步的库的表比较多时，就不能这样一一指定了，就把这个选项配置去掉，直接根据指定的库进行同步。


### 主从同步原理
	Master,记录数据更改操作
    - 启用binlog日志
    - 设置binlog日志格式
    - 设置server_id
    Slave运行2个线程
    - Slave_IO:复制master主机binlog日志到本机的relay-log文件里.
    - Slave_SQL:执行本机relay-log文件里sql语句,重现Master的数据操作.
### 配置同步
	基本构建思路
    确保数据相同
    - 从库必须要有主库上的数据.
    配置主服务器
    - 启用binlog日志,授权用户,查看当前正使用的日志
    配置从服务器
    - 设置server_id,指定从库信息
    测试配置
    - 客户端链接主库写入数据,在从库也能查到.
   
	实际操作.
    同步数据
    mysqldump -p123123 >alldata.sql
    mysql -p123123 <alldata.sql
    
	配置主库
    vim /etc/my.cnf //启用binlog日志
    [mysqld]
    	server_id=51
        log-bin=master51
    systemcctl restart mysqld
    mysql  > grant replication slave on *.* to repluser@'%' identified by "123123";
    show master status;
    配置从库
    vim /etc/my.cnf //设置server_id
    [mysqld]
    server_id=52
    systemctl restart mysqld
    mysql > change master to \
    master_host="192.168.4.51",\
    master_user="repluser",\
    master_password="123123",\
    master_log_file="master51.000002",\ //主库的binlog文件 show master 看.
    master_log_pos=442; //偏移量
    
    start slave;//启动slave
    
    show slave status\G; //查看salve状态信息
    	Master_Host:192.168.4.51 //主库IP
        Slave_IO_Running:yes ///IO线程运行状态
        Slave_SQL_Running:Yes //SQL线程运行状态
        
        从库相关的文件
        cd /var/lib/mysql
        master.info
        mysql52-relay-bin.000001
        mysql-relay-bin.index
        relay-kig.info
        
### 主从同步结构模式
#### 主从同步结构摸模式
##### 一主一从
		配置一主多从结构 把服务器53 也配置为51的从库服务器
    53: 
    	与主库数据一直
        指定server_id
        管理员登录执行主库信息
        查看IO线程和SQL线程的信息
        客户端测试配置
        
        
##### 一主多从
	1.与主库数据一直
	2.指定server_id
	3.管理云登录指定主库信息
	4.查看IO线程和SQL线程信息
	5.客户端测试配置
##### 主从从
	52 级联复制要打开 log_slave_updates
    vim /etc/my.cnf
    server_id=53
    log-bin
    binlog_format='mixed'
    log_slave_update
    
    grant replication slave on *.* to 用户名@第二台从库ip地址 identified by "密码"
 	change master to master_host="主库ip地址",
    master_user="",
    master_password="密码",
    master_log_file="binlog日志文件名",
    master_log_pos=偏移量;
    start slave;
 	

	当从库53


##### 主主结构(互为主从)
	
    达成目的,主A操作也会在主B呈现,主B操作也会在主A呈现相同效果
    注意:不需要同步用户账号信息 所以要设置一些目录不用同步
    	自增id冲突问题.
        auto_increment_offset 		表示自增长字段从哪个数开始. 1..65535 如果有n台mysql,则从第一台开始分别设置位1,2,3,..n
        auto_increment_increment 	表示自增长字段每次增量的值. 1..65535 如果有n台就设置为n
        
        第一台:
        1）在master上的my.cnf配置：
            [root@master ~]# vim /etc/my.cnf
            server-id = 1        
            log-bin = mysql-bin  
            binlog-ignore-db = mysql,information_schema
            sync_binlog = 1
            binlog_checksum = none
            binlog_format = mixed
            auto-increment-increment = 2    
            auto-increment-offset = 1   
            slave-skip-errors = all     
	
    		systemctl restart mysqld
         2) 配置数据同步授权 (防火墙允许3306)
			grant replication slave,replication client on *.* to repluser@'192.168.4.*' identified by "123123";
            flush privileges;
            
            最好将库锁住,允许读. 保证数据一致性. 在同步之后在结束. 锁住就不能向库写入数据,但重新启动之后就会解锁.
            flush tables with read lock;
            查看本日binlog信息.
            show master status; 
    
    	第二台:
           1）在master上的my.cnf配置：
        	# vim /etc/my.cnf
            server-id = 2       
            log-bin = mysql-bin  
            binlog-ignore-db = mysql,information_schema #设置忽略记录binlog日志的数据库
            sync_binlog = 1
            binlog_checksum = none
            binlog_format = mixed
            auto-increment-increment = 2    
            auto-increment-offset = 2   
            slave-skip-errors = all
         2) 配置数据同步授权 (防火墙允许3306)
			grant replication slave,replication client on *.* to repluser@'192.168.4.*' identified by "123123";
            flush privileges;
    		
            最好将库锁住,允许读. 保证数据一致性. 在同步之后在结束. 锁住就不能向库写入数据,但重新启动之后就会解锁.
            flush tables with read lock;
            查看当前binlog信息.
            show master status; 
            
         第一台:
         	解锁表
            unlock tables;
            停止slave
            stop slave;
            设置同步参数
            change master to master_host='192.168.4.55',master_user='repluser',master_password='123123',master_log_file='master-bin.000001',master_log_pos=158;
             启动slave
             start slave
			 查看slave状态
             show slave status \G;
           第二台:
           	解锁表
            unlock tables;
            停止slave
            stop slave;
            设置同步参数
            change master to master_host='192.168.4.56',master_user='repluser',master_password='123123',master_log_file='master-bin.000001',master_log_pos=166;
             启动slave
             start slave
			 查看slave状态
             show slave status \G;
             
 

 
### 主从同步常用配置参数
##### 异步复制(Asynchronous replication)
	主库执行完一次事务后,立即将结果返回给客户,不关心从库是否已经接受并处理
##### 异步复制(Fully synchronous replication)
	当主库执行完一次事务,且所有从库都执行了该事物之后才返回给客户端
##### 半同步复制(Semisynchronous replication)
	介于异步复制和全同步复制之间
    当主库在执行完一次事务后等待至少一个从库接受到并写到relay log中才返回给客户端
    

##### 模式配置
	查看是否允许动态加载模块
    	-默认允许
       	show varibleslike "lave_dynamic_loading"; #[yes|no]
        
     mysql名令行加载插件
     	用户需要SUPER权限
        
        主库上执行
        install plugin rpl_semi_sync_master SONAME 'semisync_master.so';
        从库上执行
        install plugin rpl_semi_sync_slave SONAME 'semisync_slave.so';
        
        查看插件是否启用
        select plugin_name,plugin_status from information_schema.plugins where plugin_name like "%semi%";
        
        启用半同步复制模式
        	-安装插件完成后,版同步复制默认是关闭的
            主库执行
            set global rpl_semi_sync_master_enabled=1;
            从库执行
            set global rpl_semi_sync_slave_enabled=1;
            #查看是否启用
            show varibales like 'rpl_semi_sync_%_enabled';
            
         永久启用半同步复制
         	-需要修改到主配置文件 /etc/my.cnf
            主库配置
            plugin-load=rpl_semi_sync_master=semisync_master.so
            rpl_semi_sync_master_enabled=1
            
            从库的配置
            plugin-load=rpl_semi_sync_slave=semisync_slave.so
            rpl_semi_sync_slave_enabled=1
            
         高可用架构下,master和slave需同时启动
         	-方便在切换后能继续使用半同步复制
            多台机器都要加入
            vim /etc/my.cnf
            plugin-load="rpl_semi_sync_master=semisync_master.so;rpl_semi_sync_slave=semisync_slave.so"
            rpl-semi-sync-master-enabled=1
            rpl-semi-sync-slave-enabled=1