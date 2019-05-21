回顾

环境准备:
	4台主机,3台mon+osd
	CEPH软件 [yum源]
	hosts解析,主机名称
	key,无密码链接服务器
	NTP时间服务器

部署ceph集群:
	
OSD OSD OSD OSD (ceph-osd)

	
	mon mon mon (至少三个)

ceph-deploy new node1 node2 node3
	ceph.conf + keyring
ceph-deploy install node1 node2 node3
ceph-deploy mon create-initial 

准备磁盘
prted //dev/vdb 分2个区 当做缓存盘
vdc vdd
ceph-deploy disk zap node1:vdc node1:vdd
ceph-deploy osd create node1:vdc:/dev/vdb1 



默认池子 rbd
rbd create aaa --size --image-feature
rbd resize

客户端
yum 
