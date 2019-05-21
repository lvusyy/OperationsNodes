#!/bin/bash
for i in {1..2000};do
	[ $[i%2] -eq 0 ] && echo $i || echo warn
done
