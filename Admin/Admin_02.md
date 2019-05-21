##### 课程回顾

#### 操作系统:  
+ 一堆软件的集合.让计算机硬件正常的工作.

+ Unix 系统发展  
  > 创始人: ken thompson,Dennis Ritchie  
  1970年1月1日 诞生
+ Linux 系统  
  > Linux Torwalds  
  1991年10月,发布0.02版(第一个公开版)内核  
  1994年3月,发布1.0内核

  内核:调配所有硬件  
  Linux内核+各种外围软件=一套公开发布的完整Linux系统  
  版本号:主版吧.次版本.修订号  


发行版的名称/版本由发行方决定  
- Red Hat Enterprise Linux 5/6/7 RHEL
- Suse Linux Enterprise 12
- Debian Linux 7.8
- Ubuntu Linux 14.10/15.04


安装RHEL7系统

使用硬盘
物理硬盘===>分区规划=====>格式化====>读/写文档  
毛坯楼层====>打隔断=====>装修======>入住  

格式化:赋予空间文件系统过程
文件系统(存储数据的规则)

windows文件系统
- NTFS
- FAT
Linux 文件系统
- ext4 (RHEL6)
- xfs (RHEL7)
- swap(交换文件系统) 虚拟内存:缓解内存不足

> 一些基本操作,
关闭节能  

#### Linux目录结构:  
	/ 根目录:Linux系统的起点(所有的数据都是在此目录下)  
#### Linux分区表示方式
	/dev 存放设备相关数据(硬盘 分区 键盘 鼠标 显示器 ....)
	

获取命令行界面  
*虚拟控制台切换(Ctrl+Alt+F1...9)  
- tty1:图形界面
- tty2-tty6 字符界面


