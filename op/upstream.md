#### nginx http proxy

`upstream webserver {
  server 192.168.2.100:80 weight=3 max_fails=2 fail_timeout=30;
  server 192.168.2.200:80 weight2;
}`

* weight 权重
* max_fails 最大失败次数
* fail_timeout 指定时间之内重新链接

#### 相同客户端访问相同web服务器
			  web1(登录的动态网站)
client ----- proxy
			  web2(登录动态)
			  
基于ip hash 来固定分配 web1 或 web2

upstream webserver{
    ip_hash; #
    server 192.168.2.100:80 weight=3 max_fails=2 fail_timeout=30; #单位 秒
}

* ip 前三位 md5sum %服务器数量


> 7层代理,7层调度(http)
> 4层代理,4层调度(tcp,udp)

部署支持4层TCP/UDP代理的Nginx服务器


[root@proxy ~]# yum –y install gcc pcre-devel openssl-devel        //安装依赖包
[root@proxy ~]# tar  -xf   nginx-1.12.2.tar.gz
[root@proxy ~]# cd  nginx-1.12.2
[root@proxy nginx-1.12.2]# ./configure   \
> --with-http_ssl_module                                //开启SSL加密功能
> --with-stream                                       //开启4层反向代理功能
[root@proxy nginx-1.12.2]# make && make install           //编译并安装



[root@proxy ~]# vim /usr/local/nginx/conf/nginx.conf
stream {
            upstream backend {
               server 192.168.2.100:22;            //后端SSH服务器的IP和端口
               server 192.168.2.200:22;
}
            server {
                listen 12345;                    //Nginx监听的端口
                proxy_connect_timeout 1s;   //链接时间
                proxy_timeout 3s;           //超时时间
                 proxy_pass backend;
             }
}
http {
...
}



nginx 安装 升级 虚拟主机 用户认证 https lump 动态网站 7层代理,调度 4层代理,调度


配置错误页面

error_page   404  /40x.html;    //自定义错误页面


