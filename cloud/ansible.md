ansible 扩展
## ansible 七种功能

1. ansible命令. 用于执行临时性的工作,必须掌握

2. ansible-doc 是ansible模块的文档说明,针对每个模块都有详细的说明及应用案例介绍,功能和Linux系统man命令类似,必须掌握

3. ansible-console 是ansible为用户提供的交互式工具用户可以在ansible-console 虚拟出来的终端上像shell一样使用ansible内置的各种木灵,这位习惯使用shell交互方式的用户童工了良好的使用体验
4. ansible-galaxy 从github上下载管理Roles的一款工具,与python的pip类似
5. ansible-playbook是日常应用中使用频率最高的命令,工作机制:通过读取先编写好的playbook文件实现批量管理,可以理解位按一定条件组成的ansible任务集,必须掌握
6. ansible-vault 主要用于配置文件加密,如编写的playbook文件中包含敏感信息,不想其他人随意查看,可用它加密解密这个文件
7. ansible-pull ansible有两种工作模式pull/push,默认使用朴实模式工作,pull和push工作模式相反.
	- 使用场景:有大批量机器需要配置,即便使用高并发线程依旧需要花费很多时间
	- 通常在配置大批量及其的场景下使用,灵活性稍欠缺,但效率几乎可以无线提升,对运维人员的技术水平和前沿性规划有较高要求

### json

	json是javascript对象标识法,他是一种基于文本独立于语言的轻量级数据交换格式
    json中的分隔符号限于 单引号"'".小括号"()",中括号"[]",大括号"{}",冒号":"和逗号","
    
    json特性
    	-  json纯文本
    	-  json具有"自我描述性"
    	-  json具有层级结构(值中存在值)
    	-  json可以通过JavaScript进行解析
	json语法规则
    	- 数据在名称/值对中
    	- 数据由逗号分隔
    	- 大括号保存对象
    	- 中括号保存数组
    json 数据的书写格式是:名称/值对
    	- 名称/值对包括字段名称(在双引号中) 后面写一个冒号

### yaml简介
	
    - 是一个可读性高,用来表达数据序列的格式
    - yaml(YAML Ain't Markup Language)
    - YAML参考了许多种语言,如:c,python,perl等并从xml,电子邮件的数据格式中获得灵感 clarkEvans在2001年首次发表这种语言.


	yanml基础语法
    
    - YAML的结构通过空格来韩式
    - 数组使用"- "来表示
    - 键值对使用":"来表示
    - YAML使用一个固定的缩进风格表示数据层级结构关系
    - 一般每个缩进级别由两个以上空格组成
    - # 表示注释
    注意:
    	- 不要使用tab,索引是初学者容易出错的地方之一
    	- 同一层级缩进必须对齐
   	YAML的键值表示方法
    - 采用冒号分隔
    - : 后面必须有一个空格
    - yaml键值对列子
    	"诗仙": "李白"
        或
        	"李白"
            	"诗仙"
    - 复杂yaml的键值对嵌套
    	"诗人": 
        	"李白": "诗仙"
         或
         
         "诗人":  
           "李白":
             "诗仙"
          数组
          ["李白","杜甫","白居易","李贺"]
          
        yaml 数组表示方法
          - 使用一个短横杠加一个空格
          - yaml数组列子
            - "李白"
            - "杜甫"
            - "白居易"
            - "李贺"
          - 哈希数组符合表达式
            "诗人":
              - "李白"
              - "杜甫"
              - "白居易"
              - "李贺"
            - 高级符合表达式
              "诗人":
                -
                  "李白": "诗仙"
                  "年代": "糖"
                -
                   "杜甫": "诗圣"
                   "年代":  "糖"
                -
                   "白居易": "师魔"
                   "李贺": "师鬼"
                   
### jinja2模板简介
	jinja2是什么
    	- jinja2是基于Python的模板引擎,包含变量和表达式两部分,两者在模板求值会被替换位值,模板中还有标签,控制模板的逻辑

	为啥要学习jinja2模板
    	- 因为playbook的模板使用Python的jinja2模块来处理
    jinjia2模块基本语法
    	- 模板的表达式都是包含在分隔符"{{ }}"内的
    	- 控制语句都是包含在分隔符"{% %}"内的
    	- 模板支持注释,都是包含在分隔符"{# #}"内,支持块注释
   		- 调用变量
   			{{varname}}
        - 计算
        	{{2+3}}
        - 判断
         	{{1 in [1,2,3]}}
        
    jinja2模板控制语句
    	{% if name == "诗仙" %}
        	李白
        {% elif name == "诗圣" %}
        {% elif name == "师魔" %}
        	白居易
        {% else %}
        	李贺
            
        {% endif %}
        
        {% for method in [抽烟,喝酒,烫头]  %}
        	{{do method }}
            {% endfor %}
   jinjia2模板简介
   		jinjia2 过滤器
        - 变量可以通过过滤器修改. 过滤波器与变量用管道符号(|) 分隔,也可以用圆括号传递可选参数,多个过滤器可以链式调用,前一个过滤器的输出会被作位后一个过滤器的输入
        	
            列如 把一个列表用逗号链接起来:{{ list|join(',')}}
            
            
            
## playbook是石墨
	playbook是什么
    - playbook是ansible用于配置,部署和管理托管本机剧本,
    	通过playbook的详细描述,执行其中的一系列tasks,可以让远端主机达到预期状态
        
    - 也可以说, playbook字面意思即剧本,现实中由演员按剧本表演,在ansible中由计算机进行管理,部署应用提供对外服务,以及组织计算机处理各种各样的事情.
   为什么要用playbook
   		- 执行一些简单的任务,使用ad-hoc命令可以方便的解决问题,但有时一个设施过于复杂时,执行ad-hoc命令是不合适的,最好有playbook

		- playbook可以反复使用编写的代码,可以放到 不同的机器上面,像函数一样,最大化的利用代码,在使用ansible的过程中,处理的大部分操作都是在编写playbook
	
    
    
#### playbook语法格式
	- playbook由YAML语言编写,尊新YAML标准
	- 在同一行中,#之后的内容标识注释
	- 同一个列表中的元素应该保持相同的缩进
	- playbook由一个或多个play组成
	- play中hosts,variables,roles,tasks等对象的标识方法都是键值中间以": "分隔宝石
	- YAML还有一个小的怪癖,它的文件开始行都应该是 ---,
	- 这是yaml格式的一部分,标识一个文件的开始
	
    
##### palybook构成
	- Target: 定义将要执行playbook的远程主机组
	- Variable: 定义playbook运行时需要使用的变量
	- Tasks: 定义将要在远程主机上执行的任务列表
	- Handler: 定义task执行完成以后需要调用的任务

##### playbook执行结果
	使用ansible-playbook运行playbook文件,输出内容位json格式,由不同颜色组成便于识别
    	- 绿色代表执行成功
    	- ***代表系统状态发生改变
    	- 红色代表执行失败
##### 第一个palybook

---
- host: all
  remote_user: root
  tasks:
    - ping:

ansible-playbook myping.yml -f 5
-f 并发进程数量,默认是5
-hosts行 内容是一个(多个)组或主机的patterns,以逗号位分隔符
-remote_user 账户名

tasks
	- 每一个play包含一个task列表(任务列表)
	- 一个task在其所对应的所有主机上(通过 host pattern 匹配的所有主机)执行完毕之后,下一个task才会执行
	- 有一点很重要,在一个play之中,所有hosts会获取相通的任务指令,这是play的一个目的所在,即将一组选出的hosts映射到task,执行相同的操作./
	
playbook执行命令
	- 给所有主机添加用户dalao,默认密码123123
	- 跳球第一次登录修改密码

---
- hosts: all
 remore_user: root
 tasks:
   - name: create user dalao
     user: group=wheel uid=1000 name=dalao
   - shell: echo 123123|passwd --stdin dalao
   - shell: chage -d 0 dalao




### playbook进阶


#### 语法进阶
##### 变量
##### error
##### handlers
##### when
##### register
##### with_items
##### with_nested
##### tags
##### include and roles

#### 调试
##### debug