# mycat 数据分片
###分库分表
	什么是分库分表
    	将存放在一个数据库(主机)中的数据,按照特定方式进行拆分,分散存放到多个数据库(主机)中,以达到分散单台设备的负载效果.
    
    垂值分割
    	纵向切分
        	- 将单个表,拆分成多个表,分散到不同的数据库.
        	- 将单个数据库的多个表进行分类,按业务类别分散到不同的数据库上

	水平分割
    	横向切分
        	- 按照表中某个字段的某种规则,把表中的许多记录按行切分,分散到多个数据库中



### mycat 
#### 软件介绍
		mycat 基于Java的分布式数据库系统中间层,位高并发环境的分布式访问提供解决方案
        - 支持JDBC形式链接
        - 支持MySQL,Oracle,Sqlserver,Mongodb等
        - 提供数据读写分离服务
        - 可以实现数据库服务器的高可用
        - 提供数据分片服务
        - 基于阿里巴巴cobar进行研发的开源软件
        - 适合数据大量写入数据的存储需求

#### 分片规则
		mycat 支持提供10种分片规则
        1. 枚举法 sharding-by-intfile
        2. 固定分片 rule1
        3. 范未约定 auto-sharing-long
        4. 求模法 mod-long
        5. 日期列分区法 sharing-by-date
        6. 通配取模 sharding-by-pattern
        7. ASCII码求模通配 sharding-by-prefixpattern
        8. 变成指定 sharding-by-substring
        9. 字符串拆分hash解析 sharding-by0stringhash
        10. 一致性hash sharding-by-murmur

#### 工作过程
		当mycat收到一个sql查询时
        - 先解析这个sql查找涉及到的表
        - 然后看此表的定义,如果有分片规则,则获取sql里分片字段的值,并匹配分片函数,获得分片列表
        - 然后将sql发往这些分片去执行
        - 最后手机和处理所有分片结果数据,并返回到客户端


### 配置mycat
	+ 安装jdk
		+ 系统自带即可
		+ java*openjdk-*
	安装mycat服务软件包
    	下载
        安装
    
##### 配置文件结构
	目录结构说明
    - bin 			//mycat命令.如 启动 停止 等
    - catlet		//扩展功能
    - conf			//配置文件
    - lib			//mycat使用的jar
    - log			//mycat启动日志和运行日志
    - wrapper.log	//mycat服务启动日志
    - mycat.log		//记录sql脚本执行后的报错内容
    
##### 重要配置文件说明
	 - server.xml	//设置链接mycat的账号信息
	 - schema.xml	//配置mycat的真是库表
	 - rule.xml		//定义mycat分片规则
	 配置标签说明
     - <user>..</user>  //定义连mycat用户信息
     - <datanode>.. ..</datanode>  //指定数据节点
     - <datahost>.. ..</datahost>  //指定数据库地址及用户信息

##### 修改配置文件
	修改配置文件/usr/local/mycat/conf/server.xml
    <user name="test">				//连mycat的用户名
    	<property name="password">test</property> //对应密码
        <property name="schemas">TESTDB</property>
    </user>
    <user name="user">
    	<property name="password">user</property>
        <property name="schemas">TESTDB</property>
        <property name="readOnly">true</property> //定义只读
    </user>
    
    修改配置文件/usr/local/mycat/conf/schema.xml
    - 定义分片信息
    		#逻辑库名 要与server.xml定义的一样
        <schema name="TESTDB" checkSQLschema="false" sqlMaxLimit="100">
	      #定义分片的表    
         <table name="travelrecord" dataNode="dn1,dn2" rule="auto-sharding-logn">
         #定义分片的表         
         <table name="company" primaryKey="ID"  type="global" dataNode="dn1,dn2">
         #定义分片的表    
         <table name="goods" primaryKey="ID" type="global" dataNode="dn1,dn2" >
         #定义分片的表         
         <table name="hotnews" primaryKey="ID" dataNode="dn1,dn2" rule="mod_long">
         #定义分片的表         
         <table name="employee" dataNode="dn1,dn2" rule="sharding-by-intfile">
         #定义分片的表         
         <table name="customer" dataNode="dn1,dn2" rule="sharding-by-intfile">
		</schema>
         
     修改配置文件 /usr/local/mycat/conf/schema.xml
     