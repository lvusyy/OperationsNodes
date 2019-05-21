# mysql 视图 view
	- 虚拟表
	- 内容与真实的表相似，有字段有记录
	- 试图并不在数据库中以存储的数据形式存在
	- 行和列的数据来自定义试图时查询所引用的基表，并且在具体引用试图时动态生成
	- 更新试图的数据，就是更新集表的数据
	- 更新集表数据，试图的数据也会跟着改变
	
    优点
    	简单。
        	用户不需关心试图中的数据如何查询获得
            试图中的数据已经是过滤好的符合条件的结果集
        安全。
        	用户只能看到试图中的数据
        数据独立
        	一旦试图结构确定，可以屏蔽表结构对用户的影响	
    限制
    	- 不能在视图上创建索引
    	- 在视图的from子句中不使用子查询
    	- 以下情形中的试图是不可以更新的
    		-包含以下关键字的SQL语句：聚合函数（SUM，MIN，MAX，COUNT等），SISTINC，GROUP BY ，HAVING，UNION或UNION ALL
            - 常量视图，JOIN，FROM一个不能更新的视图
            - WHERE字句的子查询引用了FORM字句中的表
            - 使用了临时表
            
            
            
#### 创建视图
	语法格式
    create view 视图名称 as sql查询；
    create view 视图名称(字段名列表) as SQL查询；
    
    **在视图表中不能以字段名的话，默认使用集表的字段名，若定义字段名的花，视图表中的字段必须和集表的字段个数相等。**
    
    
#### 查看视图
	查看当前库下所有表的状态信息
    - show table status;
    - show table status where commit="view"\G;
    - show create view 视图名； //查看参加视图具体命令；
#### 使用视图
	查询记录
    -	select 字段名列表 from 视图名 where 条件；
    插入记录
    -	insert info  视图名（字段名列表） values（字段值列表）；
    更新记录
    -	update 视图名 set 字段名=值 where 条件；
    删除记录
    -	Delete from 视图名 where 条件；
    **对视图操作即是对基表操作，反之亦然**
    删除视图
    drop view 视图名；