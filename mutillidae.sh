#!/usr/bin/env bash

if [ "$(id -u)" != "0" ]; then
    exec sudo "$0" "$@"
fi

#This repo contains php5.6
add-apt-repository ppa:ondrej/php -y
apt-get update
apt-get upgrade -y
#The downloaded mutillade will contain windows carriage return, so need dos2unix to remove
apt-get install dos2unix -y
apt-get install apache2 apache2-utils -y
sed -i 's/DirectoryIndex index.html index.cgi index.pl index.php index.xhtml index.htm/DirectoryIndex index.php index.cgi index.pl index.html index.xhtml index.htm/g' /etc/apache2/mods-enabled/dir.conf
service apache2 restart
debconf-set-selections <<< 'mysql-server mysql-server/root_password password toor'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password toor'
apt-get install mysql-server -y  
apt-get install php5.6 php5.6-xml php5.6-mbstring php5.6-fpm php5.6-mysql -y
echo "<?php phpinfo(); ?>" > /var/www/html/info.php
git clone git://git.code.sf.net/p/mutillidae/git /var/www/html/mutillidae
find /var/www/html/mutillidae -type f -exec dos2unix {} {} \;
sed -i 's/static public $mMySQLDatabaseHost = DB_HOST;/static public $mMySQLDatabaseHost = "127.0.0.1";/g'  /var/www/html/mutillidae/classes/MySQLHandler.php
sed -i 's/static public $mMySQLDatabaseUsername = DB_USERNAME;/static public $mMySQLDatabaseUsername = "root";/g'  /var/www/html/mutillidae/classes/MySQLHandler.php
sed -i 's/static public $mMySQLDatabasePassword = DB_PASSWORD;/static public $mMySQLDatabasePassword = "toor";/g'  /var/www/html/mutillidae/classes/MySQLHandler.php
sed -i 's/static public $mMySQLDatabaseName = DB_NAME;/static public $mMySQLDatabaseName = "mutillidae_testing";/g'  /var/www/html/mutillidae/classes/MySQLHandler.php
mv /var/www/html/index.html /var/www/html/info.html
service apache2 restart
clear
echo "The password for MySql root is toor"
echo "Mutillidae is at localhost:/mutillidae"
