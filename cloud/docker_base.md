### docker 自定义镜像
	流程:
    	docker pull registry
        vim /etc/docker/daemon.json
        	{
            "insecure-registries":["192.168.1.10:5000"]
            }
         - docker restart docker
         - docker run -d -p 5000:5000 redistry
         - docekr tag 镜像 IP:5000/镜像:label
         进入registry容器查看/etc/docker/registry/config.yml