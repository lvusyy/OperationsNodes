#### 远程备份磁盘

nc -l 1111|dd of=/dev/vda 服务端监听端口1111 并把接收到的数据写到//dev/vda
dd if=/dev/vda bs=1G count=4 |nc 172.25.0.10 1111    读取/dev/vda 读4g 利用nc发送172.25.0.10

sfdisk -d /dev/sdx > partition_table
sfdisk /dev/sdx < partition_table
