###	Ceph分布式存储

常用分布式文件系统
> .
Lustre
hadoop
FastDFS   国内
Ceph      红帽  提供PB级别的存储空间
Gluster    红帽

把数据分散存储在多台机器上,容量基本无上限


RBD     块存储(Iscsi)
radosgw 对象存储(访问必须写程序调用API)
mds	文件系统mount


> 架构介绍

``Ceph is a distributed object, block, and file storage platform.
也就是说，使用Ceph系统我们可以提供对象存储
块设备存储和文件系统服务，更有趣的是基于Ceph的key-value存储和NoSQL存储也在开发中，让Ceph成为目前最流行的统一存储系统。
Ceph底层提供了分布式的RADOS存储，用与支撑上层的librados和RGW、RBD、CephFS等服务。
Ceph实现了非常底层的object storage，是纯粹的SDS，并且支持通用的ZFS、BtrFS和Ext4文件系统，能轻易得Scale，没有单点故障。
接下来马上介绍Ceph的各个基础组件。```



> 基础组件


Object : Ceph最底层的存储单元是Object对象，每个Object包含元数据和原始数据。

OSD : OSD全称Object Storage

Device : 是负责响应客户端请求返回具体数据的进程。一个Ceph集群一般都有很多个OSD。

PG : PG全称Placement Grouops，是一个逻辑的概念，一个PG包含多个OSD。引入PG这一层其实是为了更好的分配数据和定位数据。

Monitor : 一个Ceph集群需要多个Monitor组成的小集群，它们通过Paxos同步数据，用来保存OSD的元数据。

RADOS : RADOS全称Reliable Autonomic Distributed Object

Store : 是Ceph集群的精华，用户实现数据分配、Failover等集群操作。

Libradio : Librados是Rados提供库，因为RADOS是协议很难直接访问，因此上层的RBD、RGW和CephFS都是通过librados访问的，目前提供PHP、Ruby、Java、Python、C和C++支持。

CRUSH : CRUSH是Ceph使用的数据分布算法，类似一致性哈希，让数据分配到预期的地方。

RBD : RBD全称RADOS block device，是Ceph对外提供的块设备服务。

RGW : RGW全称RADOS gateway，是Ceph对外提供的对象存储服务，接口与S3和Swift兼容。

MDS : MDS全称Ceph Metadata Server，是CephFS服务依赖的元数据服务。

CephFS : CephFS全称Ceph File System，是Ceph对外提供的文件系统服务。





### 增加Monitor (手动)
1. 链接到目标机器
`ssh {new-mon-host}`
2.创建Mon的默认目录 
`sudo mkdir /var/lib/ceph/mon/ceph-{mon-id}`
3. 创建临时目录
`mkdir {tmp}`
3. 获取mon的keyring文件.保存在临时目录
`ceph auth get mon. -o {tmp}/{key-filename}`
4. 获取集群的mon map 并保存到临时目录下.
`ceph mon getmap -o 临时目录下`
5. 格式化mon的数据目录 要指定mon map 文件的路径 获取法定人数的信息和集群的 fsid 和keyring 文件的路径
`sudo ceph-mon -i {monid} --mkfs --monmap {tmp}/{map-filename} --keyring {tmp}/{key-filename}`
6. 启动节点上的mon进程,它会自动加入集群. 守护进程需要知道绑定到那个IP地址 可以通过 --public-addr {ip:port} 选择指定，或在 ceph.conf 文件中进行配置 mon addr。
`ceph-mon -i {mon-id} --public-addr {ip:port}`

### 增加 Monitor（ ceph-deploy ）
1. 登入 ceph-deploy 工具所在的 Ceph admin 节点，进入工作目录。
`ssh {ceph-deploy-node}`
`cd /path/ceph-deploy-work-path`
2. 执行下列命令，新增 Monitor：
`ceph-deploy mon create {host-name [host-name]...}`
* 注意某一主机上新增 Mon 时，如果它不是由 ceph-deploy new 命令所定义的，那就必须把 public network 加入 ceph.conf 配置文件*
### 删除Monitor 
  * 当你想要删除一个 mon 时，需要考虑删除后剩余的 mon 个数是否能够达到法定人数。*
1. 停止 mon 进程。
`stop ceph-mon id={mon-id}`
2. 从集群中删除 monitor。
`ceph mon remove {mon-id}`
3. 从 ceph.conf 中移除 mon 的入口部分（如果有）。+

### 删除 Monitor（从不健康的集群中）

>本小节介绍了如何从一个不健康的集群（比如集群中的 monitor 无法达成法定人数）中删除 ceph-mon 守护进程。
1. 停止集群中所有的 ceph-mon 守护进程。
`ssh {mon-host}`
`service ceph stop mon || stop ceph-mon-all`
// and repeat for all mons
2. 确认存活的 mon 并登录该节点。
`ssh {mon-host}`
3. 提取 mon map。
`ceph-mon -i {mon-id} --extract-monmap {map-path}`
// in most cases, that's
ceph-mon -i `hostname` --extract-monmap /tmp/monmap
4. 删除未存活或有问题的的 monitor。比如，有 3 个 monitors，mon.a 、mon.b 和 mon.c，现在仅有 mon.a 存活，执行下列步骤：
```monmaptool {map-path} --rm {mon-id}
monmaptool /tmp/monmap --rm b
monmaptool /tmp/monmap --rm c```

5. 向存活的 monitor(s) 注入修改后的 mon map。比如，把 mon map 注入 mon.a，执行下列步骤：
`ceph-mon -i {mon-id} --inject-monmap {map-path}`

`ceph-mon -i a --inject-monmap /tmp/monmap`
6. 启动存活的 monitor。
7. 确认 monitor 是否达到法定人数（ ceph -s ）。
8. 你可能需要把已删除的 monitor 的数据目录 /var/lib/ceph/mon 归档到一个安全的位置。或者，如果你确定剩下的 monitor 是健康的且数量足够，也可以直接删除数据目录。
### 删除 Monitor（ ceph-deploy ）

1. 登入 ceph-deploy 工具所在的 Ceph admin 节点，进入工作目录。
`ssh {ceph-deploy-node}`
`cd /path/ceph-deploy-work-path`
2. 如果你想删除集群中的某个 Mon ，可以用 destroy 选项。
`ceph-deploy mon destroy {host-name [host-name]...}`
>注意： 确保你删除某个 Mon 后，其余 Mon 仍能达成一致。如果不可能，删除它之前可能需要先增加一个。



