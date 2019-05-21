#!/bin/bash
#while 练习

num_ExitTimes=20

while  [ ! $num_ExitTimes  -le 0 ] 
do
	let num_ExitTimes--
	sleep 0.1
done
