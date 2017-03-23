#!/bin/bash
echo "[+] downloading files"
site="http://zhiye.cdn.zhiya100.com/"
function download()
{
for url in `cat $1 | grep "onclick" | awk -F'play' '{print $2}'| awk -F',' '{print $1}'`
do
	#handle ('kp/cj-cjkjsw2017/cjkjsw-1006.wmv'
	url=${url//(\'/}
	url=${url//\'/}
	url=${url//wmv/m3u8}
	tmp=`echo $url | awk -F'/' '{print $1}'`
	tmp1=`echo $url | awk -F'/' '{print $2}'`
	file=`echo $url | awk -F'/' '{print $3}'`
	tmp2=`echo $file | awk -F'.' '{print $1}'`
	host=$site$tmp'/'$tmp1'/'$tmp2'/'$file
	echo $host
	file=${file//m3u8/mkv}
	./ffmpeg -i $host -c copy -bsf:a aac_adtstoasc $file
done
}
echo "[+] handling file swjc.txt"
download "swjc.txt"
echo "[+] handling file jjf.txt"
download "jjf.txt"
