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
apt-get install php5.6 php5.6-xml php5.6-mbstring php5.6-fpm php5.6-mysql php5.6-curl -y
apt-get install libapache2-mod-php5.6
echo "<?php phpinfo(); ?>" > /var/www/html/info.php

#INSTALLING MUTILLIDAE
git clone git://git.code.sf.net/p/mutillidae/git /var/www/html/mutillidae
find /var/www/html/mutillidae -type f -exec dos2unix {} {} \;
sed -i 's/DB_HOST/"127.0.0.1"/g'  /var/www/html/mutillidae/classes/MySQLHandler.php
sed -i 's/DB_USERNAME/"root"/g'  /var/www/html/mutillidae/classes/MySQLHandler.php
sed -i 's/DB_PASSWORD/"toor"/g'  /var/www/html/mutillidae/classes/MySQLHandler.php
sed -i 's/DB_NAME/"mutillidae"/g'  /var/www/html/mutillidae/classes/MySQLHandler.php
#mv /var/www/html/index.html /var/www/html/info.html
rm /var/www/html/index.html
service apache2 restart
clear

#INSTALLING DVWA
DVWA_VER="$(curl --silent "https://api.github.com/repos/ethicalhack3r/DVWA/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')"  #Get latest version of DVWA
echo $DVWA_VER
wget "https://github.com/RandomStorm/DVWA/archive/$DVWA_VER.zip"
unzip "$DVWA_VER.zip"
mv "$DVWA_VER" DVWA
mv DVWA/ /var/www/html/
rm "$DVWA_VER.zip" 
sed -i 's/localhost/127.0.0.1/g'  /var/www/html/DVWA/config/config.inc.php
sed -i 's/p@ssw0rd/toor/g'  /var/www/html/DVWA/config/config.inc.php
