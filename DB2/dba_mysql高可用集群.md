# MySQL高可用集群
	
    	
####MHA (Master Hight Availability)
	- 由日本DeNA公司youshimaton开发
	- 是一套优秀的实现Mysql高可用的解决方案
	- 数据库的自动故障故障切换操作能做到0-30秒之内
	- MHA能确保在故障切换过程中保证数据的一致性,以达到真正意义上的高可用.
#### MHA的组成
	- MHA Manager (管理节点)
		可以单独部署在一台独立的机器上,管理其他节点
        也可以部署在一台slave节点上
	- MHA Node (数据节点)
		运行在每台MySQL服务器上