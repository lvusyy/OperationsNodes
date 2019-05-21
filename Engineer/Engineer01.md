### 硬盘分区
	识别硬盘
	
	1. 分区规划及使用
		扇区默认大小为512字节
	
	MBR 主引导记录模式
		最大支持的空间2.2Tb
		分区类型:主分区 扩展分区 逻辑分区
		1-4个主分区,或者 3个主分区+1个扩展分区(N个逻辑分区)
		扩展分区不能格式化,不能存储数据 (创建逻辑分区)
	分区工具
	fdisk分区工具
	gnome-disks
	
	格式化文件系统
	mkfs.xfs mkfs.ext4 
	
	`blkid 显示系统硬盘分区的情况`
	`lsblk 列出块设备信息`
	`lsblk -f 列出快设备信息并带出文件系统`
	`blockdev 设置文件预读大小`

	df -h 查看磁盘剩余空间
### 开机自动挂在设备
	+ 配置文件 /etc/fstab 格式
 设备路径    挂载点 类型    参数  备份标记 检测顺序
 /dev/vdb1 /mypart1 ext4 defaults   0        0

*检测/etc/fstab 格式是否正确*
	`mount -a`
	`df -h ` 查看是否挂在成功
	lsblk  
	partprobe  刷新分区表信息 如果能看到就不用刷新
	lsblk   列出所有块设备信息


ls -l /dev/vdc*
--------------------------------------------------------------------
brw-rw----.| 1| root |disk |253,   |  32| 12月 | 8 |14:27| /dev/vdc |
brw-rw----.| 1| root |disk |253,   |  33| 12月 | 8 |14:27| /dev/vdc1|
brw-rw----.| 1| root |disk |253,   |  34| 12月 | 8 |14:27| /dev/vdc2|
----------------------|	主设备号,次设备号|--------------------------|
--------------------------------------------------------------------

- 零散空闲存储 ---- 整合的虚拟磁盘 --- 虚拟的分区
   物理卷 Physical  Volume (PV)
   卷组   Volume Group (VG)
   逻辑卷 Logical Volume (LV)

将众多的物理卷(PV),组建成卷组(VG),从卷组中划分出逻辑卷(LV)


1. 创建卷组:
	vgcreate 卷组名称 设备分区
	vgs 查看卷组信息
	pvs 查看物理卷组信息
2. 创建逻辑卷
	lvcreate -L 大小[16G] -n 逻辑卷名称 卷组名称
	lvcreate -l pe数量 -n 逻辑卷名称 卷组名称


### 逻辑卷的扩展
	
	1. 卷组有足够的空间
	  A.扩展逻辑卷的空间
	    lvgextend -L 10G /dev/nsd/lvol0
	  B.扩展文件系统
	    resize2fs:扩展ext4文件系统 (支持缩容)
	    xfs_growfs:同步/扩展xfs文件系统 xfs不支持缩容 (grow 成长/增长)
		*缩容要先从文件系统开始->逻辑卷->卷组->物理卷*
	2. 卷组没有足够的空间
	 A. 先扩展卷组
	   vgextend 卷组名称 /dev/vdc6
	 B.扩展逻辑卷的空间
	   lvgextend -L 20G /dev/nsd/lvol0
	 C.扩展文件系统
	   xfs_growfs /dev/nsd/lvol0
	
	ext4 支持缩容.xfs不支持缩容

	卷组划分空间的单位:默认4M 成为PE (物理扩展单元 Physical Extent)

	vgdisplay systemvg #闲时间组详细信息
	pe size      4.0Mib


	修改卷组的PE
	* 创建卷组是设定 pe的大小
	vgcreate -s pe大小 卷组名 空闲分区 ....
	* 修改卷组的时候设置PE大小
	vgchange -s PE大小 卷组名 空闲分区 ....

	删除卷组
		首先逻辑卷 -> 卷组 -> 物理卷
