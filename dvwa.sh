#!/usr/bin/env bash

if [ "$(id -u)" != "0" ]; then
    exec sudo "$0" "$@"
fi

apt-get update
apt-get upgrade -y
apt-get install apache2 apache2-utils -y
debconf-set-selections <<< 'mysql-server mysql-server/root_password password toor'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password toor'
apt-get install mysql-server -y

wget https://github.com/RandomStorm/DVWA/archive/v1.0.8.zip
unzip v1.0.8.zip
mv DVWA-1.0.8 DVWA
mv DVWA/ /var/www/html/
rm v1.0.8.zip 
sed -i 's/localhost/127.0.0.1/g'  /var/www/html/DVWA/config/config.inc.php
sed -i 's/p@ssw0rd/toor/g'  /var/www/html/DVWA/config/config.inc.php
rm /var/www/html/index.html
service apache2 restart
