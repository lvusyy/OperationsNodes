#### 课程回顾


#### ISCSI 网络磁盘(internet small computer system interface)
		默认端口:3260
##### 概念
	一种基于C/S架构的虚拟磁盘技术
	服务器提供磁盘空间,客户机链接并当成本地磁盘使用

	IQN作用: 1. 识别客户端 2. 标识磁盘组


	+ bakcstore,后端存储
		对应到服务端提供实际存储空间的设备,需要起一个管理名称
	+ target,磁盘组
		是客户端的访问目标,作为一个框架,由多个lun组成
	+ lun,逻辑单元 (logic unit)
		每一个个lun需要关联到某一个后端存储设备,在客户端会视为一块虚拟硬盘
	+ ISCSI Qualified Name 名称规范
		iqn.yyyy-mm.倒叙域名:自定义标识
		iqn.2018-01.com.unicom:ffffffffffff
###  服务端
##### 安装/配置
	软件包:targetcli
	服务名:target
	配置文件: rhel7 使用targetcli 交互来生成配置文件
		/etc/target/saveconfig.json

##### 操作
	新建一个分区,不要格式化
		前提准备
			1. 配置防火墙
			firewall-cmd --set-default-zone trusted
			2. 检查/安装软件包
				rpm -q targetcli

		1. 配置后端存储
			` backstores/block create dev=/dev/vdb1 name=nsd `
		2. 创建target磁盘组
			`iscsi/ create target磁盘组的名字`
			`iscsi/ create iqn.2016-02.com.example:server0`
		3. Lun关联( 将后端存储 放入 target磁盘组)
			`iscsi/iqn.2016-02.com.example:server0/tpg1/luns create /backstores/block/nsd`

		4. 配置acl访问控制
			`iscsi/iqn.2016-02.com.example:server0/tpg1/acls create iqn.2016-02.com.example:desktop0` //设置客户端的iqn
		5. 开机本地监听的IP地址与端口
			`iscsi/iqn.2016-02.com.example:server0/tpg1/protacls create 172.25.0.11 3260`

		6.重起服务
			`systemctl restart target`
	
### 客户端
	
	安装配置
	  包名:iscsi-initiator-utils
	  	扩展yum:yum的tab自动补全功能
			前提1.生成过缓存了. yum repolist
			前提2.没有安装该软件
	  配置文件:
		/etc/iscsi.initiatorname.iscsi
		`InitiatorName=iqn.2016-02.com.example:abc`
	
	  服务名:
		iscsid  只用来刷新IQN
		iscsi	客户端服务器
		操作:
		前提准备:
			配置防火墙
				firewall-cmd --set-deafult-zone trusted
		1. 安装软件包
			yum install -y iscsi-initiator-utils
		2. 修改配置文件
			vim /etc/iscsi.initiatorname.iscsi
		3. 重新启动服务 刷新客户端的IQN
			systemctl restart iscsid
		4. 发现服务端的共享存储 
		  `iscsiadm -m discovery -t st -p 服务器地址[:端口]`
		5. 重启服务 iscsi 
		  `systemctl restart iscsi`



## 数据库
	
	概念:存放数据的仓库 或 一批数据库的集合. 主流的数据库多用与存放关系型表格数据
	
		关系型数据:以为表格记录大量实体的属性信息
			DBMS,数据库管理系统
				用来操作和管理数据库
				
		常见的关系型数据库
			sql Server   微软
			DB2 	     IBM
			oracle mysql 甲骨文
			mariaDB      社区开源版
	MariaDB
		社区版mysql
		包名:maria-server
		配置文件:/etc/my.conf
			[mysqld]
			#skip-networking

		基本sql命令
		show databases;
		show tables;
		use table;
		select user();      查看当前用户名
		select database();  查看当前选则的库
		desc tables.字段;
		create database nsd1811;
		drop database nsd1811;
		
		为数据库账号修改密码
			数据库管理员:root	mysql.user
			系统管理员:root        /etc/passwd
		修改当前数据库管理root的密码为'123' 无密码修改
		mysqladmin -u root password '123' 
		mysqladmin -u root password '123' -pmima
		
		为数据库用户授权/撤销授权
		grant 权限1,权限2... on 库名.表名 to 用户@客户地址 identified by 'mima';
		撤销
		revoke 权限1,权限2.. on 库名.表名 from 用户@客户地址;
		flush privileges;
		登录本地数据库
		mysql -u root -p123
		#导入数据
		mysql -u root -p123 nsd1811 < users.sql

		操作:
		增(insert)
		删(delete)
		改(update)
		查(select)
		
		select 展示的列 from 表 where 条件;
	
		多表查询
		select 展示的列 from 表1,表2 where 条件;

