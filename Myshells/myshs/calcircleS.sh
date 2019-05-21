#!/bin/bash
#计算圆的面积
read -p 请输入圆的半径: r
[ -z $r ] &&exit 1

echo 计算结果是:`echo "$r^2*3.14"|bc`
