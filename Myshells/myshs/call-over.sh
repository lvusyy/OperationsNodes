#!/bin/bash
#点名

getNumber()
{
	number=`cat $1 |wc -l`
	echo $number
	echo $number
	#return $number
}


getPrizeID()
{
num=`getNumber "users.txt"`
let prizeID=$RANDOM%$num
let prizeID++
echo $prizeID
}


while :
do
prizeID=`getPrizeID`
#echo -ne "\r\033[31m"`sed -n $prizeID"p" users.txt`"\033[0m"
echo -n -e "\r\033[31m"`awk  "NR==$prizeID {print}" users.txt`"\033[0m"
sleep 0.03
done

#echo `sed -n $prizeID"p" users.txt`
