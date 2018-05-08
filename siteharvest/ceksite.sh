#!/bin/bash
INPUT=situs.csv
OLDIFS=$IFS
#Delimiter CSV File Menggunakan  |
IFS="|"
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
#urutan filed  username|password|organization|email
while read site
do
        echo "Site ===============================================================================================================>>> $site"
        #ping -c2 $site
	su -c "http --ignore-stdin --headers $site"
	echo ""
done < $INPUT
IFS=$OLDIFS

