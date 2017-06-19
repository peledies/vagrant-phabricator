#!/bin/bash
NAME=${1:-"phabricator.local"}
DBNAME=${2:-"phabricator"}
DBUSER=${3:-"phabricator"}
DBPASSWD=${4:-"secret"}
DBPORT=${5:-3306}
DBHOST=localhost

build_log=/home/ubuntu/build.log

echo -e "\n================================\n=== Provisioning Phabricator ===\n================================\n"

echo -e "\n--- Updating packages list ---\n"
apt-get -qq update

echo -e "\n--- Installing Required PHP Server Dependencies ---\n"
  apt-get install dpkg-dev php-dev php-cli php-json -y >> $build_log 2>&1

if [ ! -e /opt/libphutil ]
then
  echo -e "\n--- Installing libphutil ---\n"
  git clone https://github.com/phacility/libphutil.git /opt/libphutil >> $build_log 2>&1
else
  echo -e "\n--- Rebase libphutil ---\n"
  (cd /opt/libphutil && git pull --rebase >> $build_log 2>&1)
fi

if [ ! -e /opt/arcanist ]
then
  echo -e "\n--- Installing arcanist ---\n"
  git clone https://github.com/phacility/arcanist.git /opt/arcanist >> $build_log 2>&1
else
  echo -e "\n--- Rebase arcanist ---\n"
  (cd /opt/arcanist && git pull --rebase >> $build_log 2>&1)
fi

if [ ! -e /opt/phabricator ]
then
  echo -e "\n--- Installing phabricator ---\n"
  git clone https://github.com/phacility/phabricator.git /opt/phabricator >> $build_log 2>&1
else
  echo -e "\n--- Rebase phabricator ---\n"
  (cd /opt/phabricator && git pull --rebase >> $build_log 2>&1)
fi

if ! grep -Fxq "RewriteEngine on" /etc/apache2/sites-available/$NAME.conf
then
     sed -i '/<\/Directory>/a RewriteEngine on\nRewriteRule ^(.*)$          /index.php?__path__=$1  [B,L,QSA]' /etc/apache2/sites-available/$NAME.conf
fi

echo -e "\n--- Restart Apache --\n"
  service apache2 restart >> $build_log 2>&1


echo -e "\n--- Configuring Phabricator --\n"
/opt/phabricator/bin/config set mysql.host $DBHOST
/opt/phabricator/bin/config set mysql.port $DBPORT
/opt/phabricator/bin/config set mysql.user $DBUSER
/opt/phabricator/bin/config set mysql.pass $DBPASSWD
/opt/phabricator/bin/config set phabricator.show-prototypes true
/opt/phabricator/bin/storage upgrade --force