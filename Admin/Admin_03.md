#### 课程回顾

Linux修改密码

第一步：
在系统登录的界面上选择“内核”；按“e”
第二步：
在utf-8后加“rd.break console=tty0”
第三步：
ctrl+x
第四步：
switch_root#
mount -o remount,rw /sysroot
chroot /sysroot
sh_4.2#
passwd ro
touch /.autorelabel
exit
switch_root#
reboot
第二种
第一步：
在系统登录的界面上选择“内核”；按“e”
第二步：
在utf-8后加“init=/bin/sh”
第三步：
ctrl+x
第四步：
switch_root#
mount -o remount,rw /
sh_4.2#
passwd
vim /etc/selinux/config 修改成disabled
exit



#### linux命令
- 用来实现某一类功能的指令或程序
- 命令的执行以来与解释器(/bin/bash)  

#### 命令的一般格式
  - 命令字 [选项] [参数]
  - 短选项 -l
  - 多个短选项 符合选项 -ld
  - 长选项 --help

#### Linux解释器
`cat /etc/shells`   查看当前系统所支持的所有解释器

      /bin/sh
      /bin/bash *
      /sbin/nologin
      /usr/bin/sh
      /usr/bin/bash
      /usr/sbin/nologin
      /bin/tcsh
      /bin/csh
      /usr/bin/tmux

目录文件管理  

切换目录  
`cd`   .. 上层目录   . 当前目录  ~ 当前用户的家目录(存放用户配置信息)  
`cd ~用户名` 直达指定用户家目录

列出文件或目录

+ `ls -ld 目录` 查看目录详情  
+ `ls -l 目录/文件` 以长格式显示目录的内容或文件的详情  
+ `ls -A 目录` 显示包括名称以.开头的隐藏文档  
+ `ls -h 目录/文件` 易度的容量单位  
+ `ls -R 目录` 递归显示目录内容

cp [source , ...] [target] 复制文件   
/ cp s s1 s2 tg  复制多个源时候不用手动确认  
#### mount 挂载
>访问光驱内容
            /dev/hdX  ide接口  
            /dev/sr0  scsi接口  
            /dev/cdrom 链接  

`mount [选项] [参数] 设备路径 挂载点`  不要挂载到已存在或非空目录

`umount [设备路径|挂载点]`

#### 通配符
`*` 匹配任意长度任意字符
`?` 匹配一个任意字符
`[0-9a-z]` 多个字符或者连续字符中的一个,若无则忽略
`{1,2,4}`  多组不同的字符串,全匹配

#### 别名
`alias ` 查看别名   
`alisa ld='ls -d '` 设置别名  
`unalisa ld` 删除别名  


每次打开终端时生效,执行

~/.bashrc 影响指定用户
/etc/bashrc 影响所有用户


#### 注意
vim 在非root下保存文件
`w !sudo tee %`  把当前缓冲区内容从stdin传入,而 tee是一个把stdin保存到文件的小工具. % 是vim的只读寄存器,总是记录当前编辑文件的路径

.. vim 列操作 ..

删除列
1.光标定位到要操作的地方。
2.CTRL+v 进入“可视 块”模式，选取这一列操作多少行。
3.d 删除。
 
插入列
插入操作的话知识稍有区别。例如我们在每一行前都插入"() "：
1.光标定位到要操作的地方。
2.CTRL+v 进入“可视 块”模式，选取这一列操作多少行。
3.SHIFT+i(I) 输入要插入的内容。
4.ESC 按两次，会在每行的选定的区域出现插入的内容。
