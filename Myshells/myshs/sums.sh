#!/bin/bash
sum=0
i=0
while [ $i -lt 100 ] ;do
	let i++
	let sum+=i
done

echo $sum
