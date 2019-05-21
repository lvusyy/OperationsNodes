### 约束条件
> 
* null 	允许位空,默认设置
* not null    不允许为空
* key         索引类型 (键值)
* Default     设置默认值,缺省位null


### 修改表结构
* 语法结构

```alter table 表名 执行动作;```

			Add 添加字段
			Modify 修改字段类型
			Change 修改字段名
			Drop	删除字段
			Rename 修改表名
			//多个操作可以用都好分割即可.

* 添加新字段
>   alter table 表名 add 字段名 类型(宽度) 约束条件;
			[after 字段名;] //指定新字段在列表的位置
			[first;]	  //指定新的字段在列表的第一列
* 修改字段类型
> 	alter table 表名 modify 字段名 类型(宽度) 约束条件;
			[after 字段名;] //指定新字段在列表的位置
			[first;]	  //指定新的字段在列表的第一列
* 修改字段名
> 	alter table 表名 change 源字段名 新字段名 类型(宽度) 约束条件;
* 删除字段
> 	alter table 表名 drop 字段名; //整个字段下所有数据都将被删除
* 修改表名
>     alter table 表名 rename 新表名;
	  //对应的文件名也会被改变  /var/lib/mysql/库名/

## Mysql 键值

### 索引
  	   索引是对记录集的多个字段进行排序的方法
		 类似书的目录
	 	索引类型包括:Btree(二叉树) B+tree hash

* 索引优缺点

		通过穿件唯一性所以,可以保证数据库表中每一行数据的唯一性.
		可以加快数据的检索速度
* 索引缺点
		当对表中的数据进行增加,删除和修改的时候,索引也要动态维护,降低数据的维护速度
		索引需要占用物理空间

### 键值类型

* INDEX 普通索引 *

	- 一个表中可以有多个INDEX字段
	- 字段的值允许有重复明确可以赋null值
	- 经常把做查询条件的字段设置为INDEX字段
    - INDEX字段的KEY标志是MUL

#### index 索引操作
* 建表的时候指定索引字段 *
	`index(字段1),index(字段2)...`
* 在已有的表中设置index字段*
	`create index 索引名 on 表名(字段名);`
* 删除指定表的索引字段*
	`Drop index 索引名 on 表名;`
* 查看表的索引信息*
	`show index from 表名\G; `

* UNIQUE 唯一索引
* FULLTEXT 全文索引
* PRIMARY KEY 主键
* 作用,确定该数据的唯一性.*
* 复合主键 .确定插入的数据在多个字段中都保证唯一性*

* 使用规则 *
        一个表中只能一个主键字段
        对应的字段值不允许有重复,且不允许赋值null值
        如果有多个字段作为primary key , 称为符合主键,必须一起创建.
        主键字段的KEY标志是PRI
        通常与 AUTO INCREMENT 连用
        经常吧表中能够唯一表示记录的字段设置位主键字段 [记录编号字段]

  * 建表的时候指定主键字段*
	`PRIMARY KEY(字段名)`
  * 在已经有的表中设置PRIMARY KEY字段*
	`alter table 表名 add PRIMARY KEY(字段名);`
  * 移除表中的PRIMARY KEY字段*
	`alter table 表名 drop primary key;`
	     * 移除主键之前如果有自增属性,必须先去掉 *

* FOREIGEN KEY 外键
  * 让当前表字段的值在另一个表中字段值的范围内选择*
	使用外键的条件
	- 表的存储引擎必须是innodb
	- 字段类型要一致
	- 被参照字段必须是索引类型的一种(primary key)

