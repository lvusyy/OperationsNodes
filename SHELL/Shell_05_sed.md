#### sed 流式编辑器

##### sed [选项] '条件指令' 文件..

    逐行处理
    -n 屏蔽默认输出,默认sed会输出读取文档的全部内容
    -r 让sed支持扩展正则
    -i 让sed直接修改源文件,默认sed只是修改内存中数据
    
    
    
    p 显示 d 删除 s 替换 i 插入 a append
    
    case P
    sed -n '3p' /etc/passwd   #打印第三行
    sed -n '3,6p' /etc/passwd #打印三到六行
    sed -n '3p;1,8p' /etc/passwd #打印第三行和1行到8行
    sed -n '3,+10p' /etc/password #打印第三行和第三行之后的10行
    sed -n '2~2p' /etc/passwd     #打印偶数行：
    sed -n '1~2p' /etc/passwd     #打印奇数行
    sed -n '/root/p' /etc/passwd  #打印包含root行
    
    
    d
    
     sed  '3,5d' a.txt             //删除第3~5行
     sed  '/xml/d' a.txt            //删除所有包含xml的行
     sed  '/xml/!d' a.txt         //删除不包含xml的行，!符号表示取反
     sed  '/^install/d' a.txt    //删除以install开头的行
     sed  '$d' a.txt                //删除文件的最后一行
     sed  '/^$/d' a.txt             //删除所有空行
     
     
     s
     
     sed 's/xml/XML/'  a.txt        //将每行中第一个xml替换为XML
     sed 's/xml/XML/3' a.txt     //将每行中的第3个xml替换为XML
     sed 's/xml/XML/g' a.txt     //将所有的xml都替换为XML
     sed 's/xml//g'     a.txt     //将所有的xml都删除（替换为空串）
     sed 's#/bin/bash#/sbin/sh#' a.txt  //将/bin/bash替换为/sbin/sh
     sed '4,7s/^/#/'   a.txt         //将第4~7行注释掉（行首加#号）
     sed 's/^#an/an/'  a.txt         //解除以#an开头的行的注释（去除行首的#号）
     
     sed '1r b' a //使用读入功能将b文件中的内容,读入到a文件第一行的后面
     sed '2w 2.txt' a //保存第二行到2.txt
     
     
     基本动作
     -H:模式空间 --- [追加]-====> 保持空间   ||||复制
     -h:模式空间 --- [覆盖]=====>保持空间   |||复制
     
     -G:保持空间 ----[追加]=====>模式空间    |||粘贴
     -g:保持空间 ----[覆盖]=====>模式空间    |||粘贴

