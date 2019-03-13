#!/bin/bash
INPUT=userpass_od_patikab.csv
#Nama Kab/Kota Cotoh Kota Semarang
kabkota="Kabupaten Pati"
#Alamat Situs Opendata 
site=https://opendata.patikab.go.id
#Api Key dari user sysAdmin
apikey=49b86094-97c6-4566-b9ef-a4697ffd7b1e
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
	#Attach User Organization
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
