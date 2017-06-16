#!/bin/bash

NAME=${1:-"example.com"}
ADMIN=${2:-"JDoe@example.com"}
ROOT=${3:-/var/www/html/}
DIR=${4:-""} # OPTIONAL - Must not include pre slash, and must include trailing slash

vagrant_build_log=/home/ubuntu/vm_build.log

echo -e "\n=============================\n=== Provisioning Apache 2 ===\n=============================\n"

echo -e "\n--- Updating packages list ---\n"
apt-get -qq update

echo -e "\n--- Installing [Apache 2] ---\n"
  apt install apache2 -y >> $vagrant_build_log 2>&1

## Enable apache modules
echo -e "\n--- Enabling Apache module [rewrite] ---\n"
  a2enmod rewrite >> $vagrant_build_log 2>&1

echo -e "\n--- Enabling Apache module [php7.0] ---\n"
  a2enmod php7.0 >> $vagrant_build_log 2>&1

echo -e "\n--- Enabling Apache module [mpm_prefork] ---\n"
  a2enmod mpm_prefork >> $vagrant_build_log 2>&1

## Disable apache modules
echo -e "\n--- Disabling Apache module [mpm_event] ---\n"
  a2dismod mpm_event >> $vagrant_build_log 2>&1


## Create virtual host file for project
echo -e "\n--- Creating Virualhost file for $NAME ---\n"
touch /etc/apache2/sites-available/$NAME.conf
cat <<EOF > /etc/apache2/sites-available/${NAME}.conf
<VirtualHost *:80>
        ServerAdmin ${ADMIN}
        DocumentRoot ${ROOT}${DIR}
        ServerName ${NAME}
        <Directory ${ROOT}>
                Options FollowSymLinks
                AllowOverride All
                Require all granted
        </Directory>
        ErrorLog /var/log/apache2/${NAME}-error_log
        CustomLog /var/log/apache2/${NAME}-access_log common
</VirtualHost>
EOF

echo -e "\n--- Enabling $NAME ---\n"
  a2ensite $NAME >> $vagrant_build_log 2>&1

echo -e "\n--- Disabling 000-default.conf ---\n"
  a2dissite 000-default.conf >> $vagrant_build_log 2>&1

## Remove default web server directory tags from apache2.conf for security
echo -e "\n--- Removing default web server directory from apache2.conf ---\n"
  sed -i '/^<Directory[ ]\/var\/www\/>/,/<\/Directory>/d' /etc/apache2/apache2.conf >> $vagrant_build_log 2>&1

echo -e "\n--- Removing /usr/share web server directory from apache2.conf ---\n"
  sed -i '/^<Directory[ ]\/usr\/share\/>/,/<\/Directory>/d' /etc/apache2/apache2.conf >> $vagrant_build_log 2>&1

## Restart apache
echo -e "\n--- Restart Apache --\n"
  service apache2 restart >> $vagrant_build_log 2>&1
