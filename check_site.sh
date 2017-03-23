#!/bin/bash
######################################
#coded by zzt
#####################################
TIMEOUT=10
DEBUG=0

function print_blue()
{
        echo -e "\033[36m$1\033[0m"
}

function print_red()
{
        echo -e "\033[31m$1\033[0m"
}

function check_alive()
{

	ret=$(curl -I -m $TIMEOUT $1 2>&1)
	if echo "$ret" | grep "HTTP/1.1 200 OK" > /dev/null;then
		print_red "[+]alvie"
		echo "$line" >> $SITE_ALIVE
	elif echo "$ret" | grep "HTTP/1.1 302" > /dev/null;then
		print_blue "[+]relocation"
		echo "$line" >> $SITE_RELOCATION
	elif echo "$ret" | grep "curl" > /dev/null;then
		print_red "[+]access error"
		echo "$line" >> $SITE_ERROR
	elif echo "$ret" | grep "HTTP/1.1 403" > /dev/null;then
		print_blue "[+]forbidden"
		echo "$line" >> $SITE_FORBIDDED
	else
		echo "$line" >> $SITE_OTHER
		print_red "[+]I dont know what is going on"
	fi 
}

#global params
FILE=sitelist.txt
SITE_ALIVE=200.txt
SITE_RELOCATION=302.txt
SITE_FORBIDDED=403.txt
SITE_ERROR=error.txt
SITE_OTHER=other.txt
if [ -f $SITE_ALIVE or -f $SITE_FORBIDDED ];then
	rm $SITE_OTHER $SITE_ALIVE $SITE_RELOCATION $SITE_FORBIDDED $SITE_ERROR 
fi
URL='' 
k=0
line=''

echo "[+]====================================================================="
print_blue "[+]check 3000 sites alive or not"
print_red "[+]tips:"
print_red "[*]if you want to debug,set DEBUG=1,just check 5 sites and break"
print_red "[*]you can set TIMEOUT to adjust curl timeout,default 10s" 
echo "[+]====================================================================="

print_blue "[+]running now"

while read line;do
	URL=`echo $line | awk -F ' ' '{print $2}'`
	if echo $URL | grep ';' > /dev/null;then
		URL=${URL//;/ }	
		for url in $URL 
		do
			tmp=$(echo $line | awk -F ' ' '{print $2}')
			line=${line//$tmp/$url}
			echo "[+]$line"
			check_alive $url
		done
	else
		echo "[+]$line"
		check_alive $URL
	fi

	if [ $DEBUG -eq 1 ];then
		((k++))
		if [ $k -gt 5 ];then
			break
		fi
	fi
done < $FILE 

print_red "[+]check out output files [ 200.txt 302.txt 403.txt error.txt other.txt ] in current directory"
