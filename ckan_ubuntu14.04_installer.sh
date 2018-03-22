clear
echo    "# ======================================================== #"
echo    "# == CKAN simple installation for Ubuntu 14.04          == #"
echo    "#                                                          #"
echo    "# Special thanks to:                                       #"
echo    "#   						            #"
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
	echo    "# 1.1. Set site URL"
	echo    "| You site URL must be like http://localhost"
	echo -n "| Type the domain: http://"
	read v_siteurl

	echo    ""
	echo    "# 1.2. Set Password PostgreSQL (database)"
	echo    "| Enter a password to be used on installation process. "
	echo -n "| Type a password: "
	read v_password

	echo	""
	echo    "# 1.3. Set Username System Admin Open Data"
        echo    "| Your username must be like : dinkominfo"
        echo -n "| Type the username: "
        read v_sysuser

        echo    ""
        echo    "# 1.4. Set email System Admin Open Data"
        echo    "| Enter a email to be used on System Admin Open Data."
        echo -n "| Type a e-mail System Admin: "
        read v_sysemail


# Set from arguments
else
	v_siteurl=$1
	v_password=$2
	v_sysuser=$3
        v_sysemail=$4
fi

# Preparations
# ==============================================
echo    ""
echo    "# ======================================================== #"
echo    "# == 2. Update Ubuntu packages                          == #"
echo    "# ======================================================== #"
su -c "sleep 2"
su -c "echo 'deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main' > /etc/apt/sources.list.d/pgdg.list"
su -c "wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - "
apt-get update

# Add Posgres Repo
# ==============================================
echo    ""
echo    "# ======================================================== #"
echo    "# == 3. Instaling Postgres                              == #"
echo    "# ======================================================== #"
#su -c "sleep 2"
#cd /tmp
#apt-get update
sudo apt-get install -y postgresql-9.6


# Main dependences
# ==============================================
echo    "# ======================================================== #"
#echo    "# == 3. Install CKAN dependences from 'apt-get'        == #"
echo    "# ======================================================== #"
su -c "sleep 2"
sudo apt-get install -y nginx
su -c "sleep 2"
su -c "service nginx stop"
sudo apt-get install -y apache2 libapache2-mod-wsgi libpq5 redis-server git-core
su -c "service apache2 stop"
#instaling Ckan
#echo "Install CKAN"
echo    ""
echo    "# ======================================================== #"
echo    "# == 3.Instaling CKAN                                   == #"
echo    "# ======================================================== #"
su -c "sleep 2"
cd /tmp
su -c "wget http://packaging.ckan.org/python-ckan_2.7-trusty_amd64.deb"
su -c "sudo dpkg -i python-ckan_2.7-trusty_amd64.deb"

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
su postgres -c "psql --command \"CREATE USER ckan_default WITH PASSWORD '"$v_password"';\""
su postgres -c "createdb -O ckan_default ckan_default -E utf-8"
su -c "sudo -u postgres psql -l"

echo    ""
echo    "# ======================================================== #"
echo    "# == 7. Instaling Solr                                  == #"
echo    "# ======================================================== #"
su -c "sleep 2"
#echo "Install SOLR"
su -c "sudo apt-get install -y solr-jetty"

echo    ""
echo    "# ======================================================== #"
echo    "# == 8. Replace schema.xml SOLR                         == #"
echo    "# ======================================================== #"
su -c "sleep 2"
#echo "Replace Schema"
su -c "sudo mv /etc/solr/conf/schema.xml /etc/solr/conf/schema.xml.bak"
su -c "sudo ln -s /usr/lib/ckan/default/src/ckan/ckan/config/solr/schema.xml /etc/solr/conf/schema.xml"

# Create main jetty config files
echo    "# 9. Creating main configuration file at /etc/default/jetty ..."
#su -c "sleep 2"
#mkdir -p /etc/ckan/default
#chown -R ckan.ckan /etc/ckan
#su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && paster make-config ckan /etc/ckan/default/development.ini"
sed -i "s/.*NO_START.*/NO_START=0/g" /etc/default/jetty
sed -i "s/.*JETTY_HOST.*/JETTY_HOST=127.0.0.1/" /etc/default/jetty
sed -i "s/.*#JETTY_PORT.*/JETTY_PORT=8983/g" /etc/default/jetty
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
sed -i "s/.*ckan.site_url.*/ckan.site_url = http:\/\/$v_siteurl/g" /etc/ckan/default/production.ini
sed -i "s/ckan_default:pass@localhost/ckan_default:$v_password@localhost/g" /etc/ckan/default/production.ini
sed -i "s/#solr_url/solr_url/g" /etc/ckan/default/production.ini
su -c "service jetty restart"
su -c "sleep 1"
su -c "service nginx restart"
su -c "sleep 1"
su -c "service apache2 restart"
su -c "sudo ckan db init"
#sed -i "s/127.0.0.1:8983/127.0.0.1:8080/g" /etc/ckan/default/development.ini
#chown ckan.33 -R /etc/ckan/default

# Setup a storage path
#echo    "# 11. Setting a storage path for upload support..."
#su -c "sleep 2"
sudo mkdir -p /var/lib/ckan/default
#ckan.storage_path = /var/lib/ckan/default
#ckan.max_resource_size = 100
#ckan.max_image_size = 10
sed -i "s/.*ckan.storage_path.*/ckan.storage_path = \/var\/lib\/ckan\/default/g" /etc/ckan/default/production.ini
sed -i "s/.*ckan.max_resource_size.*/ckan.max_resource_size = 100/g" /etc/ckan/default/production.ini
sed -i "s/.*ckan.max_image_size.*/ckan.max_image_size = 10/g" /etc/ckan/default/production.ini
sudo chown www-data /var/lib/ckan/default
sudo chmod u+rwx /var/lib/ckan/default
su -c "sleep 1"
su -c "service apache2 restart"
#mkdir -p /var/lib/ckan
#chown -R ckan.33 /var/lib/ckan
#sed -i 's/#ckan.storage_path/ckan.storage_path/g' /etc/ckan/default/development.ini

# Create a admin account
# ==============================================
#clear
echo    "# ======================================================== #"
echo    "# == 12. CKAN System Admin Account                      == #"
echo    "# ======================================================== #"
su -c "sleep 2"
#
echo    "# 12.1 Creating a System Admin account..."
echo    "| Your account name will be : $3."
echo    "| Type the admin password:"
#su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && cd /usr/lib/ckan/default/src/ckan && paster sysadmin add admin -c /etc/ckan/default/development.ini"
#paster sysadmin add seanh email=seanh@localhost name=seanh -c /etc/ckan/default/production.ini
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && cd /usr/lib/ckan/default/src/ckan && paster sysadmin add $3 email=$4 name=$3 -c /etc/ckan/default/production.ini
"
su -c "sleep 2"

echo    ""
echo    "# ======================================================== #"
echo    "# == CKAN platform installation complete!               == #"
echo    "# ======================================================== #"
echo    "|"
echo    "# Press [Enter] to continue..."
read success
