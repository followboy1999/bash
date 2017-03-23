#!/bin/bash
# $#: params number
# $0: script name
# $1: param one = time
#date:20170303
#example: ./download_page.sh 20170101

#global var
dirpath=$1
download_base=$1


function usage()
{
	echo "[*]usage:$0 20170101"
}

function create_dir()
{
	echo "[*]first,create dir by imput date param"
	mkdir $1
}

function download()
{
	if [ -n "$dirpath" ];then
		create_dir $dirpath
		#exit
	fi
	year=${download_base:0:4}	
	month=${download_base:4:2}	
	day=${download_base:6:2}	
	#echo $year
	#echo $month
	#echo $day
	for ((i=1; i<31; i++))
	do
		if [ $i -lt 10 ];then
			page=0$i
		else
			page=$i
		fi
		url="http://paper.people.com.cn/rmrb/page/$year-$month/$day/$page/rmrb$year$month$day$page.pdf"
		if [ -f "./$dirpath/rmrb$year$month$day$page.pdf" ];then
			echo "[*]rmrb$year$month$day$page.pdf already download"
			continue
		fi
		echo "[*]download: $url"
		wget $url -P ./$dirpath 2>/dev/null
		if [ ! -f "./$dirpath/rmrb$year$month$day$page.pdf" ];then
			echo "[*]$rmrb$year$month$day$page.pdf is not exist"
			break
		fi
	done
	echo "[*]paper download task finished"
	echo "[*]download total:$[ $i - 1 ]"
}


function main()
{
	download
}

echo "[*]script for download paper"
if [ $# -ne 1 ];then
	usage
	exit
else
	main
fi	


