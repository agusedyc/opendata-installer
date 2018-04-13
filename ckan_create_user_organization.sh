#!/bin/bash
INPUT=usergrob.csv
#Nama Kab/Kota Cotoh Kota Semarang
kabkota=""
#Alamat Situs Opendata 
site=http://
#Api Key dari user sysAdmin
apikey=
OLDIFS=$IFS
#Delimiter CSV File Menggunakan  |
IFS="|"
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
#urutan filed  username|password|organization|email
while read username password organization email
do
	#Create User
	curl -d '{"name":"'$username'", "email":"'$email'","password":"'$password'","fullname":"'$organization'"}' -X POST $site/api/3/action/user_create
	#Create Organization
	curl -H "Authorization:$apikey" -d '{"name":"'$username'","description":"'$organization' '$kabkota'","title":"'$organization'"}' -X POST $site/api/3/action/organization_create
	#Create User Organization
	curl -H "Authorization:$apikey" -d '{"id":"'$username'","username":"'$username'","role":"admin"}' -X POST $site/api/3/action/organization_member_create
	#Tampilan Data
	echo "Site : $site"
	echo "User : $username"
	echo "Pass : $password"
	echo "Org  : $organization"
	echo "Email: $email"
	echo "Auth : $apikey"
	echo "Desc : $organization $kabkota"
	echo ""
done < $INPUT
IFS=$OLDIFS
