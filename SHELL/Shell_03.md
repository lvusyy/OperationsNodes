 
####  循环

```for i in a b c d
do
  echo 会被执行四次
done

for i in {1..3}
do
  echo $i次
done


for i in ` seq 1 10`
do
  echo $i次
done
```

while :
do

done

while [ 表达式 ]
do

done


case 变量 in
模式1|-模式1)
  ;;
模式2)
  ;;
 *)
 
 esac


 type 查看命令类型
 
 颜色
 \033[31m 开始
 \033[0m 结束
#### 信号机制

      2) SIGINT
      程序终止(interrupt)信号, 在用户键入INTR字符(通常是Ctrl-C)时发出，用于通知前台进程组终止进程。


      3) SIGQUIT
      和SIGINT类似, 但由QUIT字符(通常是Ctrl-\)来控制. 进程在因收到SIGQUIT退出时会产生core文件, 在这个意义上类似于一个程序错误信号。


      15) SIGTERM
      程序结束(terminate)信号, 与SIGKILL不同的是该信号可以被阻塞和处理。通常用来要求程序自己正常退出，shell命令kill缺省产生这个信号。如果进程终止不了，我们才会尝试SIGKILL。


      19) SIGSTOP
      停止(stopped)进程的执行. 注意它和terminate以及interrupt的区别:该进程还未结束, 只是暂停执行. 本信号不能被阻塞, 处理或忽略.
