# 字符串处理和正则表达式


### 字符串处理

#### 子字符串截取
    let var=字符串
    1. ${}表达式
      ${var:起始下标:长度} #从零计算
      
    2. expr substr
      expr substr "$var"  起始位置 长度  #起始位置位1
      expr substr "abcABC" 起始    长度
    3. cut工具
      echo $var |cut -b 起始-结束 #cut -b (bytes) cut -c (chractes)  1bytes=8bit
			  -3 #从第1位到第3位
			  1,3,4-9  #取第1位 第3位 第4-9位
			  3-  从第3位到最后
#### 子字符串的替换
    ${var/old/new}  #替换一行
    ${var//old/new} #替换全部匹配结果
#### 字符串的匹配删除
    
    从左删除 掐头
    #删除最短匹配
      ${var#*关键词} '#'用来删除头部,*通配
    #删除最长匹配
      ${var##*关键词} '##'用来表示最长匹配删除,*通配
    
    从右删除 去尾
    #删除最短匹配
      ${var$关键词*} '#'用来删除头部,*通配
    #删除最长匹配
      ${var$$关键词*} '##'用来表示最长匹配删除,*通配
      
#### 计算字符串长度
    ${#var}
    echo $var|awk '{print length }'
    echo "abc"|wc -L
    
#### 字符串初值
    ${var:-默认值}
    
    
#### expect 预期交互
    yum install expect
    expect << EOF
    spawn ssh root@172.25.0.11
    expect "password:" { send "123456\r" }
    expect "#" {send "touch /tmp.txt\r"}
    expect "#" {send "exit\r"}
    EOF
    
#### 数组
w=(11 22) //定义数组
w[2]=33 //赋值
echo ${w[@]} //显示w中所有的值
echo ${#w[@]} //显示数组的个数
echo ${w[@]:1:1} //利用数组下标获取数值

#### 基本正则
    ^ $ [abc] [^]
    . * \[n,m\] a\{2\} a\{2,\}
    \(\)
#### 扩展正则
    a+ ?     ^ $ [abc] [^]
    . * [n,m] a{2} a{2,} | \b
     ()
