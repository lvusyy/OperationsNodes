#### 课程回顾

shell自动补全脚本
`/etc/bash_completion`

##### strace 跟踪系统调用
*用来跟踪系统调用的简易工具,它最简单的用途就是跟踪一个程序整个生命周期里所有的系统调用，并把调用参数和返回值以文本的方式输出。*

>-c 统计每一系统调用的所执行的时间,次数和出错的次数等.  
-d 输出strace关于标准错误的调试信息.  
-f 跟踪由fork调用所产生的子进程.  
-ff 如果提供-o filename,则所有进程的跟踪结果输出到相应的filename.pid中,pid是各进程的进程号.  
-F 尝试跟踪vfork调用.在-f时,vfork不被跟踪.   
-h 输出简要的帮助信息.  
-i 输出系统调用的入口指针.  
-q 禁止输出关于脱离的消息.  
-r 打印出相对时间关于,,每一个系统调用.  
-t 在输出中的每一行前加上时间信息.  
-tt 在输出中的每一行前加上时间信息,微秒级.  
-ttt 微秒级输出,以秒了表示时间.  
-T 显示每一调用所耗的时间.  
-v 输出所有的系统调用.一些调用关于环境变量,状态,输入输出等调用由于使用频繁,默认不输出.  
-V 输出strace的版本信息.  
-x 以十六进制形式输出非标准字符串  
-xx 所有字符串以十六进制形式输出.  
-a column  
设置返回值的输出位置.默认 为40.  
-e expr  
指定一个表达式,用来控制如何跟踪.格式如下:  
[qualifier=][!]value1[,value2]...  
qualifier只能是 trace,abbrev,verbose,raw,signal,read,write其中之一.value是用来限定的符号或数字.默认的 qualifier是 trace.感叹号是否定符号.例如:  
-eopen等价于 -e trace=open,表示只跟踪open调用.而-etrace!=open表示跟踪除了open以外的其他调用.有两个特殊的符号 all 和 none.  
注意有些shell使用!来执行历史记录里的命令,所以要使用\\.  
-e trace=set  
只跟踪指定的系统 调用.例如:-e trace=open,close,rean,write表示只跟踪这四个系统调用.默认的为set=all.  
-e trace=file  
只跟踪有关文件操作的系统调用.  
-e trace=process  
只跟踪有关进程控制的系统调用.  
-e trace=network  
跟踪与网络有关的所有系统调用.  
-e strace=signal  
跟踪所有与系统信号有关的 系统调用  
-e trace=ipc  
跟踪所有与进程通讯有关的系统调用  
-e abbrev=set  
设定 strace输出的系统调用的结果集.-v 等与 abbrev=none.默认为abbrev=all.  
-e raw=set  
将指 定的系统调用的参数以十六进制显示.  
-e signal=set  
指定跟踪的系统信号.默认为all.如 signal=!SIGIO(或者signal=!io),表示不跟踪SIGIO信号.  
-e read=set  
输出从指定文件中读出 的数据.例如:  
-e read=3,5  
-e write=set  
输出写入到指定文件中的数据.  
-o filename  
将strace的输出写入文件filename  
-p pid  
跟踪指定的进程pid.  
-s strsize  
指定输出的字符串的最大长度.默认为32.文件名一直全部输出.  
-u username  
以username 的UID和GID执行被跟踪的命令  

ll 权限  
	b  块设备文件，即一些存储文件，如硬盘、软盘等，第一个字符为 [ b ]  
	c  字符设备文件，即一些串行端口的接口文件，如键盘、鼠标等， 第一个字符为[ c ]   
	s  套接字（sockets）第一个字符为[ s ]  。还被称为数据接口文件  
	p 管道（FIFO，pipe）第一个字符为[ p ］    

#### 配置dns服务器
`vim /etc/resolv.conf`  
>nameserver 223.5.5.5

#### 查看dns解析
`nslookup desktop0.example.com`

#### 重定向
>  `>`   输出覆盖重定向  
  `>>`  输出追加重定向  
  `<`   输入覆盖重定向  
  `<<`  输入追加重定向  
  `2>&-` 把错误输出关闭  
  `ls test.sh test1.sh 1>>suc.txt 2>>err.txt ` 标准输出追加到suc.txt,错误输出追加到err.txt  
  `2>&1` 把错误输出绑定到标准输出  
  `&>/dev/null` 把标准和错误都重定向到/dev/null  

>  `cat /proc/self/fd/`  
  `0 1 2 255 3 4`
  1. 0 标准输入
  2. 1 标准输出
  + 2 错误输出
  + 255 ??? 绑定到/dev/pts/0
  exec 3<>test.sh; #绑定 test.sh 的输入输出 到/proc/$$/fd/3
  所有/proc/$$/fd/3的输入输出都被重定向到test.sh这个文件

### '|' 管道命令
    将前面命令的出结果,传递到后面命令,作为后面命令的参数
    `cat /etc/passwd |tail -4 |head -5`

### 管理用户和组
*UID:用户的唯一标识  
root的UID:0  
组:方便对用户的管理,方便对权限管理  
GID:组的唯一标识*  

*Linux的用户至少属于一个组*
组:基本组 附加组(丛属组)

###### /etc/passwd 详情
>root: x:0:0:root:/root:/bin/bash
1. 用户名
2. 密码占位符
+ UID
+ 基本组的GID
+ 用户描述信息
+ 用户的家目录
+ 解释器

###### /etc/shadow
>root:$6$UiGI4Tc2$htsXYn5cJnOqv3P1VLcUSgfjDu2pL5yiJBuua6foZAHdwqeuLHfYUfS/vBn27Wjvoel8EJgtdsMjyquqvKAmf1:16261:0:99999:7:::
1. 用户名
2. 密文,* 代表账号被锁定 ,!!密码已经过期
+ 上一次修改密码的天数  距1970-1-1相隔的天数
+ 密码不可改变的天数  上次修改密码的日期+不可更改的天数<=1970-1-1距今天的天数
+ 密码有效的天数. 从1970-1-1开始计算天数
+ 修改期限前N天发出警告     
+ 密码过期的宽限,密码有效期超过了密码有效期但还在宽限期就可以修改密码是账户正常
+ 账号失效的天数, 自1970-1-1相距的天数
+ 保留

- 添加用户  
  `useradd nsd1`  
  `-u UID` 指定UID  
  `-d 家目录` 指定家目录  
  `-s shell` 指定shell /sbin/nologin 禁止登录  
  `-G tarena ` 指定附加组  

- 设置密码  
  `echo 'passwd'|passwd nsd01 --stdin`  
  `openssl passwd [passwd] | xargs useradd testuser -p`

- 切换用户  
    `su - nsd01` 切换新用户 switch user 更新环境变量

- 修改用户
  `usermod `
  >-g, --gid GROUP               强制使用 GROUP 为新主组  
  -L, --lock                    锁定用户帐号  
  -m, --move-home               将家目录内容移至新位置 (仅于 -d 一起使用)  
  -d, --home HOME_DIR           用户的新主目录  
  -s, --shell SHELL             该用户帐号的新登录 shell  
  -u, --uid UID                 用户帐号的新 UID  
  -U, --unlock                  解锁用户帐号  

- 删除用户  
`userdel testuser` 删除用户

*/etc/login.defs 这个配置文件确定了系统添加用户 相关初始信息*

### 组管理

- 新建用户组  
`groupadd [组名]`
>-g, --gid GID                 为新组使用 GID
-r, --system                  创建一个系统账户
-R, --root CHROOT_DIR         chroot 到的目录


- 配置文件说明  
+ `cat /etc/group  `  
`tarena: x:1225:nsd08,nsd11`
  + 用户组名称
  + 用户组密码
  + GID
  + 组成员用户列表 ,分隔 可空

+ `cat /etc/gshadow`  
>  `beinan:!::linuxsir`  
  `linuxsir:oUS/q7NH75RhQ::linuxsir`
  + 用户组名
  + 用户组密码
  + 用户组的管理者
  + 用户组所拥有的成员用','分隔

* grpconv 命令来同步/etc/group 和/etc/gshadow两个文件的内容*

  - 组成员管理  
    `gpasswd -a username groupname` 将指定用户加入指定用户组中
    `gpasswd -d username groupname` 将指定用户从指定用户组中移除

  -  一次为组中加入多个成员  
    `gpasswd -M user1,user2,user3 groupName`

  -  查询一个组下的所有成员  
    `groupmems -g 组名 -l`

  - 修改用户组  
    `groupmod [-g 组id] [-n 新组名]`

    `groupmems -g 组名   -p, --purge     `  从组中移除所有成员  
    `groupmems  -g 组名 -d, --delete username `        从组的成员中删除用户 username

  - 删除用户组  
  `groupdel 组名` 不允许删除用户的基本组

### echo 回显
      支持转义字符串
      在BASH下,用echo -e \\n or echo -e "\n"
      在ASH下,用echo \\n
      在SH下,用echo -e \\n or echo -e "\n"
      在BSH下,用echo \\n
      在TCSH下,用echo \\n

#### date
` date '+%Y-%m-%d %H:%M:%S'`
`date -s '2008-8-8 8:8:8'`
`ntpdate ntp1.aliyun.com ` 自动同步阿里云 阿里云的ntp服务器[ntp1...ntp7]


#### tr 裁剪


#### 压缩解压缩 打包解包
>tar备份与恢复  
作用:1.将零散的文件归档到一个文件  
     2.减少空间的占用

归档含义
- 将许多零散的文件整理为一个文件
- 文件总的大小基本不变  

压缩的含义
- 压缩:按某种算法减少文件所占用空间的大小
- 解压:按对应的逆向算法解压


|后缀  |    命令工具名称 |
|------|:--------------:|
|.gz   |    gzip       |
|.bz2  |    bzip2      |
|.xz   |    xz         |

tar 选项 压缩包的名字 被压缩的源文档....

1. -c :创建归档 create
2. -x :释放归档 extract
- -f :指定归档文件名称,必须放到所有选项的最后 file
- -z -j -J :调用.gz .bz2 .xz 格式的工具进行处理
- -t :显示归档中的文件清单
- -C :指定释放的路径
- -v :显示进度

打包压缩
>tar -cfz /opt/tt.gz /etc/passwd /etc/shadow  
tar -cfj /opt/tt.bz2 /etc/passwd /etc/shadow  
tar -cfJ /opt/tt.xz /etc/passwd /etc/shadow  

解压缩  
>tar -xf /opt/tt.gz -C /  

查看压缩包内文件  
>tar -tf /opt/tt.xz  

#### NTP时间同步
1. NTP为完全为客户机提供标准时间
2. NTP客户机需要与NTP服务器保持沟通

NTP服务器:虚拟机Classroom
NTP客户端:虚拟机Server
    a. 安装chrony软件包
    rpm -q chrony

    yum install chrony
    b.改配置文件
      /etc/chrony.conf
        [server classroom.example.com iburst]
    c. 重启服务
      systemctl restart chronyd #重启服务
      systemctl enable chronyd #配置自启动
    d.验证
      `date -s '2000-1-1'`
      `date`
      `systemctl restart chronyd`
      `sleep 3`
      `date`
&copy;
