### 虚拟机镜像快照
1. 
cd /var/lib/libvirt/images
>基于rh7_template.img 创建一个快照
qemu-img create -f qcow2 -b .rh7_template.img newrh7.qcow2 10G

2.  拷贝配置文件,修改
cp .rhel7.xml /etc/libvirt/qemu/newrh7.xml
修改虚拟机名称:newrh7
修改虚拟机硬盘:/var/lib/libvirt/images/newrh7.qcow2

3. 注册虚拟机
`virsh define /etc/libvirt/qemu/newrh7.xml`
