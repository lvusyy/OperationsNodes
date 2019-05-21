#### DNS 分离解析
	split 分离解析
	1. 根据原地址集合将客户机分类
	2. 根据策略为不同客户机分配不同的IP
	3. 分类要合理,所有的客户端都要找到自己的分类(必须要匹配得到.)

	BIND
	模板 (匹配模式,由上至下,匹配及停)
	view "联通"{

	>match-clients { 来源地址1;192.168.4.7...; }
	zone "12306.cn" IN {
		type master;
		file 12306.cn.unicom.zone;	
			};
		};

	view "电信"{

	match-clients { 来源地址1;192.168.4.207;...; }
	zone "12306.cn" IN {
		type master;
		file 12306.cn.chinanet.zone;	
			};
		};
	
	view "其它未分组"{

	match-clients { any; }
	zone "12306.cn" IN {
		type master;
		file 12306.cn.any.zone;	
			};
		};


  	二. 针对来源地址定义acl列表
		若地址很少,也可以不用设置
		
		acl 声明和引用
		acl "名称" { 192.168.2.1;192.168.0.0/24; };
		view "nsd"{
			match-clients { 名称; };
			....	
		};




	### DAID 磁盘阵列
		* 廉价冗余磁盘陈列*
		- Redundant Arrays of Indexpensive Disks
		-  通过硬件/软件技术,将多个较小/低速的磁盘整合成一个大磁盘
		-  阵列的价值:提升I/OXIAOL,硬件级别的数据冗余
		-  不同RAID级别的功能,特性各不相同
			

		1. RAID 0 条带模式
		  -  同一个文档分散存放在不同磁盘
		  -  并行写入提高效率
		  -  没有数据冗余
		2.  RAID 0/1/10
		  -  RIAD 1 ,镜像模式
		   	-  一个文档复制成多分,分别写入不同磁盘
			-  多分拷贝提生可靠性,效率无提升
		  -  RAID 0+1 1+0
		     -  整合RAID0,RAID1的有势
		     -  并行存取提高效率,镜像写入提高可靠性
		  -  RAID 5/6
			- 高性价比模式
			- 相当于RAID0和RAID1的折中方案
			- 需要至少一块磁盘的容量来存放校验数据,容许丢失一块硬盘的内容
		  	-RAID 6
			- 比RAID5 更好的性价比.
			-相当于扩展的TAID5阵列,提供2份独立校验方案
			-需要至少两快磁盘的容量来存放校验数据.	
	### 进程管理
	• ps — Processes Snapshot
	– 格式:ps [选项]...

	• 常用命令选项
	– aux:显示当前终端所有进程(a)、当前用户在所有
	    终端下的进程(x), 以用户格式输出(u)
	– -elf:显示系统内所有进程(-e)、以长格式输出(-l)
	    信息、包括最完整的进程信息(-f)


	• ps aux 操作
	  – 列出正在运行的所有进程

	• ps -elf 操作(父进程的PPID)
	  – 列出正在运行的所有进程


	  如果想计算正在运行的进程个数？
	[root@svr7 /]# wc -l /etc/passwd
	[root@svr7 /]# ps aux | wc -l

	[root@svr7 /]# find /etc/  -name "*tab" | wc -l
	[root@svr7 /]# find /etc/ -name "*.conf" | wc -l

	  请统计/boot/文件有多少个？
	[root@svr7 /]# find /boot/ -type f | wc -l

	#######
	进程动态排名
	• top 交互式工具
	– 格式:top [-d 刷新秒数] [-U 用户名]

	[root@svr7 /]# top -d 1

	   按 P（大写） 按照CPU使用进行排序
	   按 M（大写） 按照内存使用进行排序

	######
	### 检索进程
	• pgrep — Process Grep
	– 用途:pgrep [选项]... 查询条件

	• 常用命令选项
	– -l:输出进程名,而不仅仅是 PID
	– -U:检索指定用户的进程
	– -t:检索指定终端的进程


	### 进程的前后台调度
	• 后台启动
	– 在命令行末尾添加“&”符号,不占用当前终端
	• Ctrl + z 组合键
	– 挂起当前进程(暂停并转入后台)
	• jobs 命令
	– 查看后台任务列表
	• fg 命令
	– 将后台任务恢复到前台运行
	• bg 命令
	– 激活后台被挂起的任务


	### 杀死进程
	• 干掉进程的不同方法
	– Ctrl+c 组合键,中断当前命令程序
	– kill [-9] PID... 
	– killall [-9] 进程名...
	– pkill  查找条件   

	### 日志管理
	• 系统和程序的“日记本”
	– 记录系统、程序运行中发生的各种事件
	– 通过查看日志,了解及排除故障
	– 信息安全控制的“依据”


	 /var/log/messages    记录内核消息、各种服务的公共消息
	 /var/log/dmesg 	    记录系统启动过程的各种消息
	 /var/log/cron        记录与cron计划任务相关的消息
	 /var/log/maillog     记录邮件收发相关的消息
	 /var/log/secure      记录与访问限制相关的安全消息

	• 由系统服务rsyslog统一记录/管理
	 – 日志消息采用文本格式
	 – 主要记录事件发生的时间、主机、进程、内容

	日志的优先级
	linux内核定义的时间紧急程度
	- 0~7 工8种优先级别
	 0	EMERG(紧急)	会导致主机系统不可用的情况
	 1	ALERT(警告)	必须马上采取措施解决的问题
	 2	CRIT(严重)	比较严重的情况
	 3	ERR(错误)	运行出现错误
       4	WARNING(提醒)可能会影响系统功能的事件
	 5	NOTICE(注意) 不会影响系统但值得注意
	 6	INFO(信息)	
	 7	DEBUG(调试)


	journalctl
		提取由systemd-journal 服务搜集的日志
			-主要包括内核/系统日志,服务日志
		  常见用法
			-  journalctl |grep 关键词
			-  journalctl -u 服务名 [-p 优先级]
			-  journalctl -n 消息条数
			-  journalctl --since="yyyy-mm-dd HH:MM:SS" --until="yyyy-mm-dd HH:MM:SS"
	

	systemd
		一个更高效的系统&服务管理器
		-  开机服务并行启动,各种系统服务间的精确依赖
		-  配置目录:/etc/systemd/system/
		-  服务目录:/lib/systemd/system/
		-  主要管理工具:systemctl

[root@pc ~]# ls -l /sbin/init
lrwxrwxrwx. 1 root root 22 4月  29 2018 /sbin/init -> ../lib/systemd/systemd

	unit配置单元
	 不同的unit决定了一组相关的启动任务
	 -  service : 		后台独立服务
	 -  socket:			套接字,类似xinetd管理的临时服务
	 -  target:			一台配置单元的组合,类似与传统 "运行级别"
	 -  device:			对应udev规则标记的某个设备
	 -  mount,automount:	挂载点,触发挂载点
	
	常用功能:
	+  列出活动的系统服务
		- systemctl -t service
	+  列出所有系统服务(包括不活动的)
		-  systemctl -t service -all
	+  列出可用运行级别
		-  systemctl -t target
	+  切换到文本/图形模式
		-  systemctl isolate multi-user.target
		-  systemctl isolate graphical.target
	
	运行级别:
		  
         0：关机   
         1：单用户模式（基本功能的实现，破解Linux密码）  
	 2：多用户字符界面（不支持网络）  
	 3：多用户字符界面（支持网络）服务器默认的运行级别  
	 4：未定义
	 5：图形界面  
	 6：重起   

		init 0

	runlevel 确认当前运行级别
	N 3
	旧级别 当前级别
	
	#### 设置默认级别
		查看默认级别
		systemctl get-default
		设置默认级别
		systemctl set-default multi-user.target
		systemctl set-default graphical.target

