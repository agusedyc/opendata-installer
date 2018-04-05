clear
echo    "# ======================================================== #"
echo    "# == CKAN simple installation for Ubuntu 14.04          == #"
echo    "#															#"
echo    "# Created By:												#"
echo    "#															#"
echo    "# ======================================================== #"
su -c "sleep 3"	

# Get parameters from user
# ==============================================
echo    ""
echo    "# ======================================================== #"
echo    "# == 1. Set main config variables                       == #"
echo    "# ======================================================== #"
echo    ""

# No arguments sent. Interactive input.
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
	# echo    "# 1.1. Set site URL"
	# echo    "| You site URL must be like http://localhost"
	# echo -n "| Type the domain: http://"
	# read v_siteurl

	echo    ""
	echo    "# 1.2. Set Password PostgreSQL (database)"
	echo    "| Enter a password to be used on installation process. "
	echo -n "| Type a password: "
	read v_password

	# echo	""
	# echo    "# 1.3. Set Username System Admin Open Data"
 #    echo    "| Your username must be like : dinkominfo"
 #    echo -n "| Type the username: "
 #    read v_sysuser

 #    echo    ""
 #    echo    "# 1.4. Set email System Admin Open Data"
 #    echo    "| Enter a email to be used on System Admin Open Data."
 #    echo -n "| Type a e-mail System Admin: "
 #    read v_sysemail


# Set from arguments
else
	# v_siteurl=$1
	v_password=$2
	# v_sysuser=$3
    # v_sysemail=$4
fi

echo    ""
echo    "# ======================================================== #"
echo    "# == 4. Show Databases Postgre                          == #"
echo    "# ======================================================== #"
su -c "sleep 2"
#echo "Show database"
su -c "sudo -u postgres psql -l"

#echo    ""
#echo    "# ======================================================== #"
#echo    "# == 5. Create user ckan_default                        == #"
#echo	"# Masukan PASSWORD database dan SIMPAN JANGAN SAMPAI LUPA  #"
#echo    "# ======================================================== #"
#su -c "sleep 2"
#su -c "sudo -u postgres createuser -S -D -R -P ckan_default"
#echo    ""
#echo    "# ======================================================== #"
#echo    "# == 6. Create Databases ckan_default Postgre           == #"
#echo    "# ======================================================== #"
#su -c "sleep 2"
#su -c "sudo -u postgres createdb -O ckan_default ckan_default -E utf-8"
echo    ""
echo    "# ======================================================== #"
echo    "# == 5-6. Setup a PostgreSQL database                   == #"
echo    "# ======================================================== #"
su -c "sleep 2"
su postgres -c "psql --command \"CREATE USER datastore_default WITH PASSWORD '"$v_password"';\""
su postgres -c "createdb -O ckan_default datastore_default -E utf-8"
su -c "sudo -u postgres psql -l"


# Create main jetty config files
# echo    "# 9. Creating main configuration file at /etc/default/jetty ..."
#su -c "sleep 2"
#mkdir -p /etc/ckan/default
#chown -R ckan.ckan /etc/ckan
#su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && paster make-config ckan /etc/ckan/default/development.ini"
# sed -i "s/.*NO_START.*/NO_START=0/g" /etc/default/jetty
# sed -i "s/.*JETTY_HOST.*/JETTY_HOST=127.0.0.1/" /etc/default/jetty
# sed -i "s/.*JETTY_PORT.*/JETTY_PORT=8983/g" /etc/default/jetty
#sed -i "s/ckan_default:pass@localhost/ckan_default:$v_password@localhost/g" /etc/ckan/default/development.ini
#sed -i "s/#solr_url/solr_url/g" /etc/ckan/default/development.ini
#sed -i "s/127.0.0.1:8983/127.0.0.1:8080/g" /etc/ckan/default/development.ini
#chown ckan.33 -R /etc/ckan/default

# Create main CKAN config files
echo    "# 10. Creating main configuration file at /etc/ckan/default/development.ini ..."
#su -c "sleep 2"
#mkdir -p /etc/ckan/default
#chown -R ckan.ckan /etc/ckan
#su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && paster make-config ckan /etc/ckan/default/development.ini"
# sed -i "s/.*ckan.site_url.*/ckan.site_url = http:\/\/$v_siteurl/g" /etc/ckan/default/production.ini
# Sql
# sed -i "s/.*sqlalchemy.url.*/sqlalchemy.url = postgresql://ckan_default:$v_password@localhost/ckan_default/g" /etc/ckan/default/production.ini
sed -i "s/datastore_default:pass@localhost/datastore_default:$v_password@localhost/g" /etc/ckan/default/production.ini
sed -i "s/#ckan.datastore.write_url/ckan.datastore.write_url/g" /etc/ckan/default/production.ini
sed -i "s/#ckan.datastore.read_url/ckan.datastore.read_url/g" /etc/ckan/default/production.ini
# ckan.plugins = datastore
sed -i "s/#ckan.plugins =/ckan.plugins = datastore/g" /etc/ckan/default/production.ini

# ckan.datastore.write_url = postgresql://ckan_default:pass@localhost/datastore_default
# sed -i "s/.*ckan.datastore.write_url.*/sqlalchemy.url = ckan.datastore.write_url = postgresql://ckan_default:$v_password@localhost/datastore_default/g" /etc/ckan/default/production.ini
# ckan.datastore.read_url = postgresql://datastore_default:pass@localhost/datastore_default
# sed -i "s/.*ckan.datastore.read_url.*/sqlalchemy.url = ckan.datastore.read_url = postgresql://datastore_default:$v_password@localhost/datastore_default/g" /etc/ckan/default/production.ini
# sed -i "s/.*#solr_url.*/solr_url = http://127.0.0.1:8983/solr/g" /etc/ckan/default/production.ini
su -c "sudo -u postgres psql && sudo ckan datastore set-permissions | sudo -u postgres psql --set ON_ERROR_STOP=1"
su -c "service apache2 restart"
#mkdir -p /var/lib/ckan
#chown -R ckan.33 /var/lib/ckan
#sed -i 's/#ckan.storage_path/ckan.storage_path/g' /etc/ckan/default/development.ini

# Create a admin account
# ==============================================
#clear
# echo    "# ======================================================== #"
# echo    "# == 12. CKAN System Admin Account                      == #"
# echo    "# ======================================================== #"
# su -c "sleep 2"
#
# echo    "# 12.1 Creating a System Admin account..."
# echo    "| Your account name will be : $3."
# echo    "| Type the admin password:"
#su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && cd /usr/lib/ckan/default/src/ckan && paster sysadmin add admin -c /etc/ckan/default/development.ini"
# su -c "sleep 2"

echo    ""
echo    "# ======================================================== #"
echo    "# == CKAN platform installation complete!               == #"
echo    "# ======================================================== #"
echo    "|"
echo    "# Press [Enter] to continue..."
read success

# #Konfigurasi Harvest
# ckan.harvest.mq.type = redis
# ckan.harvest.mq.hostname = localhost
# ckan.harvest.mq.port = 6379
# ckan.harvest.mq.redis_db = 0
# ckan.harvest.log_scope = 0
# ckan.harvest.log_timeframe = 10
# ckan.harvest.log_level = info