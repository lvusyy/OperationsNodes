#!/bin/bash
#九九乘法表

for i in {1..9};do
	for i2 in `seq 1 $i`;do
		echo -n "${i}*${i2}=$[i*i2] "
	done
	echo
done
