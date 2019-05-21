#!/bin/bash

for i in `ls /etc/*.conf`;do
	filename=`echo $i|  awk -F '/' '{print $3}' `
        tar -cPjf "${filename}_`date +"%Y%m%d_%H%M%S"`.tar.bz2" $i
done
