### shell



#### 常用的shell
```]# cat /etc/shells
/bin/sh
/bin/bash
/sbin/nologin
/bin/tcsh
/bin/csh
/bin/ksh                                        //确认当前系统已识别ksh
```


#### 常用快捷键
-----
|Ctrl+A		|将光标移动到行首
|Ctrl+E		|将光标移动到行首
|Ctrl+C		|终止操作
|Ctrl+D		|一般为结束输入
|Ctrl+M		|回车
|Ctrl+U		|删除光标至行首的所有内容
|Ctrl+W		|删除光标前面的一个单词(空格分隔)
|Ctrl+S		|挂起,冻结终端
|Ctrl+K		|删除光标后面的所有字符
|Ctrl+S		|挂起,冻结终端
|Ctrl+Q		|解除冻结终端
|Alt+.		|使用前一个命令的最后一个词
|方向键(上下键) |历史命令
|Tab键		|补齐命令,选项,路径与文件名 (补齐选项需要 bash-completion 软件包)
------

history -c 
> ~/.bash_history


重定向
> >> < << &> 2> >&2 2>&1 

source shell.sh  用当前解释器来运行脚本
bash/sh  shell.sh 新开启一个进程来运行脚本

read [-p 提示信息] 变量名 从

stty -echo 设置当前终端不显示用户输入的信息
stty echo  设置当前终端显示用户输入的信息

export 变量名 导出变量到全局变量

$PS1 一级提示 在用户终端中 命令 前显示的字符
$PS2 二级提示 当程序需要用户输入时,输出的字符

set 可查看所有变量 (包括env能看到环境变量)
echo ${v1}aa  切分变量和普通字符串