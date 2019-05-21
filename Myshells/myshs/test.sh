#!/bin/bash
#计算6倍数

for i in {1..20}
do
	[ $[i%6] -eq 0 ] && echo $[i*i]||continue	
done
